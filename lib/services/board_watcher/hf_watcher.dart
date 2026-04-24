// lib/services/board_watcher/hf_watcher.dart
// Per-HF-converter polling loop: initial IR check + persistent status polling.
import 'package:flutter/foundation.dart';

import 'dart:async';

import 'cu16c_protocol.dart';
import 'hf_connection.dart';
import 'hf_socket.dart';
import 'locker_api_client.dart';

String _ts() {
  final n = DateTime.now();
  return '${n.hour.toString().padLeft(2, '0')}:'
      '${n.minute.toString().padLeft(2, '0')}:'
      '${n.second.toString().padLeft(2, '0')}.'
      '${n.millisecond.toString().padLeft(3, '0')}';
}

class _BoardState {
  Map<int, int> prevIr   = {};
  Map<int, int> prevLock = {};
  bool initialized = false;
}

class HfWatcher {
  final HFConnection connection;
  final LockerApiClient api;
  final double pollSec;
  final double sockTimeout;

  const HfWatcher({
    required this.connection,
    required this.api,
    required this.pollSec,
    required this.sockTimeout,
  });

  // ---- IR check helpers ----

  Future<Map<int, String>> _checkIrEachChannel(HfSocket sock, int cuAddr) async {
    final st = await queryStatus(sock, cuAddr, sockTimeout);
    if (st == null) return {for (var ch = 1; ch <= 16; ch++) ch: 'NO_DATA'};
    return {
      for (var ch = 1; ch <= 16; ch++)
        ch: (st['ir'] as Map<int, int>)[ch] == 1 ? 'DETECTED' : 'EMPTY'
    };
  }

  Future<void> _printAllBoardsStatus(HfSocket sock) async {
    final cus = connection.cuAddresses;
    debugPrint('\n[${_ts()}] ${'=' * 50}');
    debugPrint('[${_ts()}] ALL BOARDS IR STATUS CHECK');
    debugPrint('[${_ts()}] ${'=' * 50}');
    for (final cuAddr in cus) {
      final hex      = '0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      final status   = await _checkIrEachChannel(sock, cuAddr);
      final detected = status.entries.where((e) => e.value == 'DETECTED').map((e) => e.key).toList();
      final noData   = status.entries.where((e) => e.value == 'NO_DATA').length;
      final empty    = status.entries.where((e) => e.value == 'EMPTY').length;
      if (noData == 16) {
        debugPrint('[${_ts()}] CU $hex: ✗ NO DATA (board offline?)');
      } else {
        debugPrint('[${_ts()}] CU $hex: DETECTED=${detected.isEmpty ? 'none' : detected} | EMPTY=$empty channels');
      }
    }
    debugPrint('[${_ts()}] ${'=' * 50}\n');
  }

  Future<bool> _initialIrCheck(HfSocket sock) async {
    final cus = connection.cuAddresses;
    debugPrint('\n[${_ts()}] Initial IR Sensor Check (CU16C Protocol 0x70)');
    debugPrint('=' * 50);
    var anyConnected = false;
    for (final cuAddr in cus) {
      final hex    = '0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      final status = await _checkIrEachChannel(sock, cuAddr);
      debugPrint('\nCU $hex:');
      var hasData = false;
      for (var ch = 1; ch <= 16; ch++) {
        final val  = status[ch]!;
        final icon = val == 'NO_DATA' ? '✗' : val == 'DETECTED' ? '✓' : '○';
        debugPrint('  CH${ch.toString().padLeft(2, '0')}: $icon $val');
        if (val != 'NO_DATA') hasData = true;
      }
      if (hasData) {
        anyConnected = true;
        debugPrint('  >>> Board $hex: ONLINE');
      } else {
        debugPrint('  >>> Board $hex: OFFLINE or NO RESPONSE');
      }
    }
    debugPrint('=' * 50);
    return anyConnected;
  }

  // ---- Main run loop ----

  /// Runs initial IR check then polls indefinitely until [stopFuture] completes.
  Future<void> run(
    Map<int, Map<int, Map<String, dynamic>>> allLockerMaps,
    Future<void> stopFuture,
  ) async {
    final label = 'HF(${connection.ip}:${connection.port})';
    final cus   = connection.cuAddresses;
    bool stopped = false;
    stopFuture.then((_) => stopped = true);

    // Step 1: Initial IR check
    HfSocket? initSock;
    try {
      initSock = await HfSocket.connect(connection.ip, connection.port);
      if (initSock == null) throw Exception('cannot connect');
      final boardsOk = await _initialIrCheck(initSock);
      if (!boardsOk) {
        debugPrint('\n[${_ts()}] $label ERROR: No boards responding. Notifying API...');
        for (final cuAddr in cus) {
          await api.notifyBoardOffline(allLockerMaps[cuAddr] ?? {}, cuAddr,
              alertType: 'cu_offline',
              alertMessage:
                  'CU 0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()} '
                  'not responding on ${connection.ip}:${connection.port}');
        }
        return;
      }
      debugPrint('\n[${_ts()}] $label IR check passed. Continuing...\n');
    } catch (e) {
      debugPrint('[${_ts()}] $label Connection failed: $e');
      for (final cuAddr in cus) {
        await api.notifyBoardOffline(allLockerMaps[cuAddr] ?? {}, cuAddr,
            alertType: 'hf_offline',
            alertMessage: 'HF converter ${connection.ip}:${connection.port} cannot connect: $e');
      }
      return;
    } finally {
      await initSock?.close();
    }

    // Step 2: Persistent polling with auto-reconnect
    final states          = {for (final a in cus) a: _BoardState()};
    final failCounts      = {for (final a in cus) a: 0};
    final reportedOffline = {for (final a in cus) a: false};
    const failThreshold   = 3;
    const heartbeatSec    = 60;
    const apiRetrySec     = 30;
    const reconnectDelay  = Duration(seconds: 5);
    var lastHeartbeat = DateTime.now();
    var lastApiRetry  = DateTime.now();

    while (!stopped) {
      // Connect
      HfSocket? sock;
      try {
        sock = await HfSocket.connect(connection.ip, connection.port);
        if (sock == null) throw Exception('cannot connect');
        debugPrint('[${_ts()}] $label Polling socket connected');
      } catch (e) {
        debugPrint('[${_ts()}] $label Polling connection failed: $e — retrying in 5s');
        for (final cuAddr in cus) {
          await api.notifyBoardOffline(allLockerMaps[cuAddr] ?? {}, cuAddr,
              alertType: 'hf_offline',
              alertMessage: 'HF converter ${connection.ip}:${connection.port} cannot connect: $e');
        }
        await Future.delayed(reconnectDelay);
        continue;
      }

      try {
        // Initialize boards not yet read
        for (final cuAddr in cus) {
          final state = states[cuAddr]!;
          if (state.initialized) continue;
          final st = await queryStatus(sock, cuAddr, sockTimeout);
          if (st == null) {
            debugPrint('[${_ts()}] $label WARN: No reply from CU 0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}');
            continue;
          }
          state.prevIr   = Map.from(st['ir']   as Map<int, int>);
          state.prevLock = Map.from(st['lock'] as Map<int, int>);
          state.initialized = true;
          final hex = cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase();
          debugPrint('[${_ts()}] $label CU 0x$hex START IR=   ${List.generate(16, (i) => '${i + 1}:${state.prevIr[i + 1]}').join(', ')}');
          debugPrint('[${_ts()}] $label CU 0x$hex START LOCK= ${List.generate(16, (i) => '${i + 1}:${state.prevLock[i + 1]}').join(', ')}');
          final lockerMap = allLockerMaps[cuAddr] ?? {};
          for (var ch = 1; ch <= 16; ch++) {
            if (lockerMap.containsKey(ch)) {
              await api.syncStatusToApi(lockerMap, cuAddr, ch, state.prevIr[ch]!, state.prevLock[ch]!);
            }
          }
          await Future.delayed(const Duration(milliseconds: 100));
        }
        debugPrint('');

        // Polling loop
        while (!stopped) {
          final now = DateTime.now();

          // Heartbeat
          if (now.difference(lastHeartbeat).inSeconds >= heartbeatSec) {
            for (final cuAddr in cus) {
              final state = states[cuAddr]!;
              if (!state.initialized) continue;
              final hex      = cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase();
              final locked   = state.prevLock.entries.where((e) => e.value == 1).map((e) => e.key).toList();
              final occupied = state.prevIr.entries.where((e) => e.value == 1).map((e) => e.key).toList();
              debugPrint('[${_ts()}] $label ♥ CU 0x$hex ALIVE | locked=$locked | occupied=$occupied');
            }
            lastHeartbeat = now;
          }

          // Retry locker map for CUs with no data
          final missing = cus.where((a) => (allLockerMaps[a] ?? {}).isEmpty).toList();
          if (missing.isNotEmpty && now.difference(lastApiRetry).inSeconds >= apiRetrySec) {
            debugPrint('[${_ts()}] $label Retrying locker map for ${missing.map((a) => '0x${a.toRadixString(16).padLeft(2, '0').toUpperCase()}').toList()}...');
            final apiData = await api.fetchLockerData();
            if (apiData != null) {
              final newMaps = LockerApiClient.buildLockerMapForAllCus(apiData, missing);
              for (final entry in newMaps.entries) {
                final cuAddr = entry.key;
                final lmap   = entry.value;
                if (lmap.isNotEmpty) {
                  allLockerMaps[cuAddr] = lmap;
                  final state = states[cuAddr];
                  if (state != null && state.initialized) {
                    for (var ch = 1; ch <= 16; ch++) {
                      if (lmap.containsKey(ch)) {
                        await api.syncStatusToApi(lmap, cuAddr, ch, state.prevIr[ch]!, state.prevLock[ch]!);
                      }
                    }
                  }
                }
              }
            }
            lastApiRetry = DateTime.now();
          }

          // Poll each CU
          for (final cuAddr in cus) {
            final state = states[cuAddr]!;
            if (!state.initialized) continue;

            final st2 = await queryStatus(sock, cuAddr, sockTimeout);
            if (st2 == null) {
              failCounts[cuAddr] = failCounts[cuAddr]! + 1;
              final hex = cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase();
              debugPrint('[${_ts()}] $label WARN: CU 0x$hex timeout (fail ${failCounts[cuAddr]}/$failThreshold)');
              if (failCounts[cuAddr]! >= failThreshold && !reportedOffline[cuAddr]!) {
                await api.notifyBoardOffline(allLockerMaps[cuAddr] ?? {}, cuAddr,
                    alertType: 'cu_offline',
                    alertMessage: 'CU 0x$hex stopped responding ($failThreshold consecutive timeouts)');
                reportedOffline[cuAddr] = true;
              }
              continue;
            }

            if (failCounts[cuAddr]! > 0 || reportedOffline[cuAddr]!) {
              final hex = cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase();
              if (reportedOffline[cuAddr]!) debugPrint('[${_ts()}] $label CU 0x$hex is back ONLINE');
              failCounts[cuAddr]      = 0;
              reportedOffline[cuAddr] = false;
            }

            final curIr    = st2['ir']   as Map<int, int>;
            final curLock  = st2['lock'] as Map<int, int>;
            final irChg    = diffChannels(state.prevIr,   curIr);
            final lockChg  = diffChannels(state.prevLock, curLock);
            final lockerMap = allLockerMaps[cuAddr] ?? {};
            final hex = cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase();

            if (irChg.isNotEmpty || lockChg.isNotEmpty) {
              for (final c in irChg) {
                final ch = c[0], pv = c[1], cv = c[2];
                debugPrint('[${_ts()}] $label CU 0x$hex IR   CH${ch.toString().padLeft(2, '0')}: $pv -> $cv   (${labelIr(cv)})');
                if (lockerMap.isNotEmpty) await api.syncStatusToApi(lockerMap, cuAddr, ch, cv, curLock[ch]!);
              }
              for (final c in lockChg) {
                final ch = c[0], pv = c[1], cv = c[2];
                debugPrint('[${_ts()}] $label CU 0x$hex LOCK CH${ch.toString().padLeft(2, '0')}: $pv -> $cv   (${labelLock(cv)})');
                if (lockerMap.isNotEmpty) await api.syncStatusToApi(lockerMap, cuAddr, ch, curIr[ch]!, cv);
              }
              debugPrint('[${_ts()}] $label CU 0x$hex RAW  ${hexDump(st2['raw'] as List<int>)}');
              await _printAllBoardsStatus(sock);
            }

            state.prevIr   = Map.from(curIr);
            state.prevLock = Map.from(curLock);
            await Future.delayed(const Duration(milliseconds: 50));
          }

          await Future.delayed(Duration(milliseconds: (pollSec * 1000).toInt()));
        }
      } catch (e) {
        debugPrint('[${_ts()}] $label Connection lost: $e — reconnecting in 5s');
        for (final cuAddr in cus) {
          await api.notifyBoardOffline(allLockerMaps[cuAddr] ?? {}, cuAddr,
              alertType: 'hf_offline',
              alertMessage: 'HF converter ${connection.ip}:${connection.port} connection lost: $e');
        }
      } finally {
        await sock.close();
      }

      if (!stopped) await Future.delayed(reconnectDelay);
    }
    debugPrint('[${_ts()}] $label Watcher stopped.');
  }
}
