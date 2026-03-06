import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceConfigService {
  static const _keyDeviceId = 'device_id';
  static const _keyBaseUrl = 'base_url';
  static const _keyLockerIds = 'locker_ids';

  static String _deviceId = '';
  static String _baseUrl = '';
  static String _appKey = '';
  static List<int> _lockerIds = [];

  static String get deviceId => _deviceId;
  static String get baseUrl => _baseUrl;
  static String get appKey => _appKey;
  static List<int> get lockerIds => _lockerIds;

  static bool get hasLockers => _lockerIds.isNotEmpty;

  /// Call once in main() before runApp.
  /// [bootstrapUrl] is the initial URL used to reach the API (from compile-time env).
  /// [appKey] is the static proxy auth token (from compile-time env).
  static Future<void> init({
    required String bootstrapUrl,
    required String appKey,
  }) async {
    _appKey = appKey;

    final prefs = await SharedPreferences.getInstance();

    // Generate device ID on first run, then persist it forever
    String? storedId = prefs.getString(_keyDeviceId);
    if (storedId == null || storedId.isEmpty) {
      storedId = _generateUuid();
      await prefs.setString(_keyDeviceId, storedId);
    }
    _deviceId = storedId;

    // Use stored base URL if available, otherwise fall back to bootstrap URL
    _baseUrl = prefs.getString(_keyBaseUrl) ?? bootstrapUrl;

    // Load cached locker IDs (used when network is unavailable)
    final storedLockers = prefs.getString(_keyLockerIds);
    if (storedLockers != null && storedLockers.isNotEmpty) {
      _lockerIds = storedLockers
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }
  }

  /// Call after a successful API response to persist the latest server config.
  static Future<void> updateFromServer({
    String? baseUrl,
    List<int>? lockerIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (baseUrl != null && baseUrl.isNotEmpty) {
      await prefs.setString(_keyBaseUrl, baseUrl);
      _baseUrl = baseUrl;
    }

    if (lockerIds != null) {
      await prefs.setString(_keyLockerIds, lockerIds.join(','));
      _lockerIds = lockerIds;
    }
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
