// lib/services/offline_status_queue.dart
// Persists /unlock_locker calls that could not reach the backend while offline.
// When the backend becomes reachable again, flush() replays them so the locker
// UI transitions from red (occupied) to green (available).
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class _PendingUnlock {
  final int lockerUnitId;
  final String pin;
  final bool stillUse;
  final String timestamp; // original unlock time

  const _PendingUnlock({
    required this.lockerUnitId,
    required this.pin,
    required this.stillUse,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'locker_unit_id': lockerUnitId,
        'pin':            pin,
        'still_use':      stillUse,
        'timestamp':      timestamp,
      };

  factory _PendingUnlock.fromJson(Map<String, dynamic> j) => _PendingUnlock(
        lockerUnitId: j['locker_unit_id'] as int,
        pin:          j['pin']            as String,
        stillUse:     j['still_use']      as bool,
        timestamp:    j['timestamp']      as String,
      );
}

class OfflineStatusQueue {
  static const _key = 'offline_unlock_queue';
  static final List<_PendingUnlock> _queue = [];

  static int get pendingCount => _queue.length;

  /// Load persisted queue from SharedPreferences. Call once on startup.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw   = prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      _queue
        ..clear()
        ..addAll(list.map((e) => _PendingUnlock.fromJson(e as Map<String, dynamic>)));
      if (_queue.isNotEmpty) {
        debugPrint('[OfflineQueue] Loaded ${_queue.length} pending unlock(s) to replay');
      }
    } catch (_) {}
  }

  /// Queue an /unlock_locker call that failed because the backend was offline.
  static Future<void> add({
    required String lockerId,
    required String pin,
    required bool stillUse,
  }) async {
    final id = int.tryParse(lockerId);
    if (id == null) return;
    _queue.add(_PendingUnlock(
      lockerUnitId: id,
      pin:          pin,
      stillUse:     stillUse,
      timestamp:    DateTime.now().toIso8601String(),
    ));
    await _save();
    debugPrint('[OfflineQueue] Queued unlock for locker $lockerId '
        '(${_queue.length} total pending)');
  }

  /// Replay all pending unlocks using [sender].
  /// Successfully replayed entries are removed; failed ones are kept for retry.
  static Future<void> flush(
      Future<bool> Function(int lockerUnitId, String pin, bool stillUse, String timestamp) sender,
  ) async {
    if (_queue.isEmpty) return;
    debugPrint('[OfflineQueue] Replaying ${_queue.length} pending unlock(s)…');
    final sent = <_PendingUnlock>[];
    for (final u in List.of(_queue)) {
      try {
        final ok = await sender(u.lockerUnitId, u.pin, u.stillUse, u.timestamp);
        if (ok) sent.add(u);
      } catch (_) {}
    }
    _queue.removeWhere(sent.contains);
    await _save();
    if (sent.isNotEmpty) {
      debugPrint('[OfflineQueue] Replayed ${sent.length} unlock(s). '
          '${_queue.length} still pending.');
    }
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key, jsonEncode(_queue.map((e) => e.toJson()).toList()));
  }
}
