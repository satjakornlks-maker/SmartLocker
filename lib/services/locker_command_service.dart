// lib/services/locker_command_service.dart
// Sends unlock commands directly to the HF converter via TCP.
// Used when the backend is offline — bypasses the API entirely.
//
// Flow: set trigger time to 0 → send unlock → restore trigger time to 60s

import 'board_watcher/cu16c_protocol.dart';
import 'board_watcher/hf_connection.dart';
import 'board_watcher/hf_socket.dart';

class _LockerLocation {
  final String ip;
  final int port;
  final int cuAddr;
  final int ch;
  const _LockerLocation(this.ip, this.port, this.cuAddr, this.ch);
}

class LockerCommandService {
  static final Map<String, _LockerLocation> _map = {}; // lockerId → location

  /// Called by BoardWatcher after it resolves HF connections and locker maps.
  /// Builds a reverse lookup: lockerId → { ip, port, cuAddr, channel }.
  static void register(
    List<HFConnection> connections,
    Map<int, Map<int, Map<String, dynamic>>> allLockerMaps,
  ) {
    _map.clear();
    for (final conn in connections) {
      for (final cuAddr in conn.cuAddresses) {
        final lockerMap = allLockerMaps[cuAddr] ?? {};
        for (final entry in lockerMap.entries) {
          final ch     = entry.key;
          final locker = entry.value;
          final id     = locker['id']?.toString();
          if (id != null) {
            _map[id] = _LockerLocation(conn.ip, conn.port, cuAddr, ch);
          }
        }
      }
    }
    print('[LockerCmd] Registered ${_map.length} lockers for offline unlock');
  }

  /// Unlocks [lockerId] immediately (no door push required) via direct TCP.
  /// Returns true if the commands were sent successfully.
  static Future<bool> unlockImmediate(String lockerId) async {
    final loc = _map[lockerId];
    if (loc == null) {
      print('[LockerCmd] No location for locker $lockerId — cannot unlock offline');
      return false;
    }

    HfSocket? sock;
    try {
      sock = await HfSocket.connect(loc.ip, loc.port);
      if (sock == null) {
        print('[LockerCmd] Cannot connect to ${loc.ip}:${loc.port}');
        return false;
      }

      // Step 1: set trigger time to 0 (immediate — no push needed)
      await sendTriggerTime(sock, loc.cuAddr, 0);
      await Future.delayed(const Duration(milliseconds: 100));

      // Step 2: send unlock
      await sendUnlock(sock, loc.cuAddr, loc.ch);
      await Future.delayed(const Duration(milliseconds: 300));

      // Step 3: restore trigger time to 60s
      await sendTriggerTime(sock, loc.cuAddr, 60);

      print('[LockerCmd] Offline unlock OK — locker $lockerId '
          '(${loc.ip} CU 0x${loc.cuAddr.toRadixString(16).toUpperCase()} CH${loc.ch})');
      return true;
    } catch (e) {
      print('[LockerCmd] Unlock error: $e');
      return false;
    } finally {
      await sock?.close();
    }
  }
}
