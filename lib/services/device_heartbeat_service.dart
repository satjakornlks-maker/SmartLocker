// lib/services/device_heartbeat_service.dart
// Sends a periodic HTTP ping to the backend so it knows this device is alive.
// The backend (Hangfire job) marks a device offline if no ping is received
// within 15 minutes and creates an alert.
// Interval is 5 minutes — short enough to pick up assignment changes quickly,
// well within the 15-minute offline threshold.

import 'dart:async';
import 'package:untitled/services/api_service.dart';
import 'package:untitled/services/device_config_service.dart';

class DeviceHeartbeatService {
  static Timer? _pingTimer;
  static bool _stopped = false;
  static String? _deviceId;

  static const _interval = Duration(minutes: 5);

  /// Starts the periodic ping loop.
  static Future<void> connect(String baseUrl, String deviceId) async {
    _stopped  = false;
    _deviceId = deviceId;

    // Send an immediate ping on start, then every 5 minutes.
    await _sendPing();

    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_interval, (_) => _sendPing());
  }

  /// Stops the ping loop.
  static Future<void> disconnect() async {
    _stopped = true;
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  // ---- Internal ----

  static Future<void> _sendPing() async {
    if (_stopped || _deviceId == null) return;
    final data = await ApiService().pingHealth(_deviceId!);
    final ok = data != null;
    print('[heartbeat] ping ${ok ? 'ok' : 'failed'} (device: $_deviceId)');
    if (ok) {
      print('[heartbeat] raw response: $data');
      final lockerIds = (data['locker_ids'] as List?)
          ?.map((e) => (e as num).toInt())
          .toList() ?? [];
      final assignedLocker = data['assigned_locker'] != null
          ? (data['assigned_locker'] as num).toInt()
          : null;
      final systemMode = data['system_mode'] as String?;

      final prevLockerIds = List<int>.from(DeviceConfigService.lockerIds);
      print('[heartbeat] before update — lockerIds=$prevLockerIds, assignedLocker=${DeviceConfigService.assignedLocker}, systemMode=${DeviceConfigService.systemMode}');
      await DeviceConfigService.updateFromServer(
        lockerIds:      lockerIds,
        assignedLocker: assignedLocker,
        systemMode:     systemMode,
      );
      print('[heartbeat] after update  — lockerIds=${DeviceConfigService.lockerIds}, assignedLocker=${DeviceConfigService.assignedLocker}, systemMode=${DeviceConfigService.systemMode}');

      // If locker assignment changed, refresh locker data cache and PIN cache
      // so the screen shows new lockers without requiring a restart.
      final lockerIdsChanged = prevLockerIds.toString() != lockerIds.toString();
      if (lockerIdsChanged) {
        print('[heartbeat] locker IDs changed — refreshing locker data and PIN cache');
        final api = ApiService();
        await api.getLocker();
        await api.syncPinCache();
        print('[heartbeat] locker data and PIN cache refreshed');
      }
    }
  }
}
