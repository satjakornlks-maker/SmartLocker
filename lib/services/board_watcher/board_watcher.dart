// lib/services/board_watcher/board_watcher.dart
// Orchestrates the CU16C board monitoring system inside the Flutter app.
// Run as a background Future: boardWatcher.start().ignore()
// Stop cleanly on shutdown:   boardWatcher.stop()
import 'package:flutter/foundation.dart';

import 'dart:async';

import 'hf_watcher.dart';
import 'locker_api_client.dart';
import '../locker_command_service.dart';

String _ts() {
  final n = DateTime.now();
  return '${n.hour.toString().padLeft(2, '0')}:'
      '${n.minute.toString().padLeft(2, '0')}:'
      '${n.second.toString().padLeft(2, '0')}.'
      '${n.millisecond.toString().padLeft(3, '0')}';
}

class BoardWatcher {
  final String apiBaseUrl;
  final String apiKey;
  final int assignedLocker;
  final double pollSec;
  final double sockTimeout;
  final int restartHour;
  final String hfConnectionsOverride;

  /// Called instead of exit(0) when the daily restart timer fires.
  final Future<void> Function()? onDailyRestart;

  Completer<void>? _stopCompleter;

  BoardWatcher({
    required this.apiBaseUrl,
    required this.apiKey,
    required this.assignedLocker,
    required this.pollSec,
    required this.sockTimeout,
    required this.restartHour,
    required this.hfConnectionsOverride,
    this.onDailyRestart,
  });

  /// Fetches HF config + locker data and registers locker locations for offline
  /// unlock — without starting any polling loops. Lightweight alternative to [start].
  Future<void> registerOnly() async {
    final api = LockerApiClient(
      apiBaseUrl:            apiBaseUrl,
      assignedLocker:        assignedLocker,
      hfConnectionsOverride: hfConnectionsOverride,
      headers: {
        'x-app-token':  apiKey,
        'Content-Type': 'application/json',
      },
    );

    final hfConnections  = await api.resolveHfConnections();
    final allCuAddresses = hfConnections.expand((c) => c.cuAddresses).toList();
    final apiData        = await api.fetchLockerData();
    final allLockerMaps  = apiData != null
        ? LockerApiClient.buildLockerMapForAllCus(apiData, allCuAddresses)
        : <int, Map<int, Map<String, dynamic>>>{};

    if (apiData == null) debugPrint('[${_ts()}] WARN: Could not fetch locker data — offline unlock map will be empty');

    LockerCommandService.register(hfConnections, allLockerMaps);
  }

  /// Starts all watcher loops. Blocks until [stop] is called.
  Future<void> start() async {
    _stopCompleter = Completer<void>();
    final stopFuture = _stopCompleter!.future;

    final api = LockerApiClient(
      apiBaseUrl:            apiBaseUrl,
      assignedLocker:        assignedLocker,
      hfConnectionsOverride: hfConnectionsOverride,
      headers: {
        'x-app-token':  apiKey,
        'Content-Type': 'application/json',
      },
    );

    debugPrint('=' * 60);
    debugPrint('CU16C Multi-Board Watcher (embedded)');
    debugPrint('Protocol: CU16C v5.2 (Command 0x70)');
    debugPrint('=' * 60);
    debugPrint('API: $apiBaseUrl  | Poll: ${pollSec}s');

    final hfConnections  = await api.resolveHfConnections();
    final allCuAddresses = hfConnections.expand((c) => c.cuAddresses).toList();

    for (var i = 0; i < hfConnections.length; i++) {
      debugPrint('  [${i + 1}] ${hfConnections[i]}');
    }
    debugPrint('Total CUs: ${allCuAddresses.map((a) => '0x${a.toRadixString(16).padLeft(2, '0').toUpperCase()}').toList()}');
    debugPrint('');

    final apiData = await api.fetchLockerData();
    final allLockerMaps = apiData != null
        ? LockerApiClient.buildLockerMapForAllCus(apiData, allCuAddresses)
        : <int, Map<int, Map<String, dynamic>>>{};

    if (apiData == null) debugPrint('[${_ts()}] WARN: Could not fetch locker data from API');

    // Register locker locations so offline unlock works without the backend.
    LockerCommandService.register(hfConnections, allLockerMaps);

    await Future.wait([
      _dailyRestartWatcher(stopFuture),
      for (final conn in hfConnections)
        HfWatcher(
          connection:  conn,
          api:         api,
          pollSec:     pollSec,
          sockTimeout: sockTimeout,
        ).run(allLockerMaps, stopFuture),
    ]);

    debugPrint('[${_ts()}] All watchers stopped.');
  }

  /// Signals all loops to exit gracefully.
  void stop() {
    if (_stopCompleter != null && !_stopCompleter!.isCompleted) {
      _stopCompleter!.complete();
    }
  }

  Future<void> _dailyRestartWatcher(Future<void> stopFuture) async {
    bool stopped = false;
    stopFuture.then((_) => stopped = true);

    final now    = DateTime.now();
    var target   = DateTime(now.year, now.month, now.day, restartHour);
    if (!target.isAfter(now)) target = target.add(const Duration(days: 1));

    var remainSecs = target.difference(now).inSeconds;
    debugPrint('[${_ts()}] Daily restart scheduled at $target (in ${(remainSecs / 3600).toStringAsFixed(1)}h)');

    while (remainSecs > 0 && !stopped) {
      final chunk = remainSecs < 60 ? remainSecs : 60;
      await Future.delayed(Duration(seconds: chunk));
      remainSecs -= chunk;
    }

    if (!stopped) {
      debugPrint('[${_ts()}] Daily restart triggered.');
      await onDailyRestart?.call();
    }
  }
}
