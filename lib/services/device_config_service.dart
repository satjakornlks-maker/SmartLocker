import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceConfigService {
  static const _keyDeviceId      = 'device_id';
  static const _keyLockerIds      = 'locker_ids';
  static const _keyAssignedLocker = 'assigned_locker';
  static const _keySystemMode     = 'system_mode';
  static const _keyLastConfigUrl  = 'last_config_url';

  static String _deviceId      = '';
  static String _baseUrl       = '';
  static String _appKey        = 'flutter-secret-2026';
  static List<int> _lockerIds  = [];
  static int _assignedLocker   = 0;
  static String _systemMode    = 'B2C'; // default until synced from server

  static String get deviceId      => _deviceId;
  static String get baseUrl       => _baseUrl;
  static String get appKey        => _appKey;
  static List<int> get lockerIds  => _lockerIds;
  static int get assignedLocker   => _assignedLocker;
  static String get systemMode    => _systemMode;

  static bool get hasLockers => _lockerIds.isNotEmpty;

  /// Call once in main() before runApp.
  /// [configUrl] is always read from config.json on disk — no caching of the URL.
  /// Changing config.json and restarting the app always picks up the new URL.
  static Future<void> init({
    required String configUrl,
    required String appKey,
  }) async {
    _appKey = appKey;
    // URL is always taken from config.json — never from a cached value.
    _baseUrl = configUrl;

    final prefs = await SharedPreferences.getInstance();

    // Generate device ID on first run, then persist it forever.
    String? storedId = prefs.getString(_keyDeviceId);
    if (storedId == null || storedId.isEmpty) {
      storedId = _generateUuid();
      await prefs.setString(_keyDeviceId, storedId);
    }
    _deviceId = storedId;

    // If config.json URL changed since last run, wipe all server-specific cache
    // (auth tokens, locker list, mode) so stale data is not shown.
    final lastUrl = prefs.getString(_keyLastConfigUrl) ?? '';
    if (lastUrl != configUrl) {
      await prefs.remove('auth_access_token');
      await prefs.remove('auth_access_expiry');
      await prefs.remove('auth_refresh_token');
      await prefs.remove('auth_refresh_expiry');
      await prefs.remove(_keyLockerIds);
      await prefs.remove(_keyAssignedLocker);
      await prefs.remove(_keySystemMode);
      await prefs.setString(_keyLastConfigUrl, configUrl);
    }

    // Load cached locker IDs (used when network is unavailable).
    final storedLockers = prefs.getString(_keyLockerIds);
    if (storedLockers != null && storedLockers.isNotEmpty) {
      _lockerIds = storedLockers
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }

    // Load cached assigned locker (the locker cabinet this device belongs to).
    _assignedLocker = prefs.getInt(_keyAssignedLocker) ?? 0;

    // Load cached system mode (falls back to default 'B2C' if never synced).
    _systemMode = prefs.getString(_keySystemMode) ?? 'B2C';
  }

  /// Call after a successful API sync to persist the latest server config.
  /// Note: base URL is NOT updated here — it is always sourced from config.json.
  static Future<void> updateFromServer({
    List<int>? lockerIds,
    int? assignedLocker,
    String? systemMode,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (lockerIds != null) {
      final prev = List<int>.from(_lockerIds);
      await prefs.setString(_keyLockerIds, lockerIds.join(','));
      _lockerIds = lockerIds;
      if (prev.toString() != lockerIds.toString()) {
        debugPrint('[DeviceConfig] locker_ids changed: $prev → $lockerIds');
      }
    }

    if (assignedLocker != null && assignedLocker > 0) {
      final prev = _assignedLocker;
      await prefs.setInt(_keyAssignedLocker, assignedLocker);
      _assignedLocker = assignedLocker;
      if (prev != assignedLocker) {
        debugPrint('[DeviceConfig] assigned_locker changed: $prev → $assignedLocker');
      }
    }

    if (systemMode != null && systemMode.isNotEmpty) {
      final prev = _systemMode;
      await prefs.setString(_keySystemMode, systemMode);
      _systemMode = systemMode;
      if (prev != systemMode) {
        debugPrint('[DeviceConfig] system_mode changed: $prev → $systemMode');
      }
    }
  }

  /// Call when the user changes the server URL in Settings.
  /// Updates the in-memory URL immediately and clears all stale auth tokens
  /// and cached config so the next API call re-authenticates against the new server.
  static Future<void> updateBaseUrl(String newUrl) async {
    newUrl = newUrl.trim();
    if (newUrl.isEmpty || newUrl == _baseUrl) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_access_token');
    await prefs.remove('auth_access_expiry');
    await prefs.remove('auth_refresh_token');
    await prefs.remove('auth_refresh_expiry');
    await prefs.remove(_keyLockerIds);
    await prefs.remove(_keyAssignedLocker);
    await prefs.remove(_keySystemMode);
    await prefs.setString(_keyLastConfigUrl, newUrl);
    _baseUrl = newUrl;
    _lockerIds = [];
    _assignedLocker = 0;
    _systemMode = 'B2C';
    debugPrint('[DeviceConfig] baseUrl updated to $newUrl');
  }

  static String _generateUuid() {
    final random = Random.secure();
    final v = List<int>.generate(16, (_) => random.nextInt(256));
    v[6] = (v[6] & 0x0f) | 0x40; // version 4
    v[8] = (v[8] & 0x3f) | 0x80; // variant 1
    String h(int n) => n.toRadixString(16).padLeft(2, '0');
    return '${h(v[0])}${h(v[1])}${h(v[2])}${h(v[3])}'
        '-${h(v[4])}${h(v[5])}'
        '-${h(v[6])}${h(v[7])}'
        '-${h(v[8])}${h(v[9])}'
        '-${h(v[10])}${h(v[11])}${h(v[12])}${h(v[13])}${h(v[14])}${h(v[15])}';
  }
}
