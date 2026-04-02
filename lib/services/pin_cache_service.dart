// lib/services/pin_cache_service.dart
// Caches SHA-256 hashed PINs per locker unit for offline PIN verification.
// The backend returns hashed PINs — raw PINs never leave the server.

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinCacheService {
  static const _key = 'pin_cache';
  static const _bypassKey = 'bypass_pin_cache';
  static Map<String, String> _cache = {};       // lockerId → sha256(pin)
  static Map<String, String> _bypassCache = {}; // lockerId → sha256(bypass_pin)

  /// Loads the cached PIN hashes from SharedPreferences into memory.
  /// Call once on app startup before any verification.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      _cache = Map<String, String>.from(jsonDecode(json));
      print('[PinCache] Loaded ${_cache.length} cached PIN hashes');
    }
    final bypassJson = prefs.getString(_bypassKey);
    if (bypassJson != null) {
      _bypassCache = Map<String, String>.from(jsonDecode(bypassJson));
      print('[PinCache] Loaded ${_bypassCache.length} cached bypass PIN hashes');
    }
  }

  /// Replaces the regular PIN cache with [pinHashes] and persists to SharedPreferences.
  /// [pinHashes] is { lockerId: sha256(pin) } from the backend.
  static Future<void> update(Map<String, String> pinHashes) async {
    _cache = Map.from(pinHashes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_cache));
    print('[PinCache] Updated: ${_cache.length} lockers cached');
    _cache.forEach((id, hash) => print('[PinCache]   locker $id → hash: $hash'));
  }

  /// Replaces the bypass PIN cache with [pinHashes] and persists to SharedPreferences.
  /// [pinHashes] is { lockerId: sha256(bypass_pin) } from the backend.
  static Future<void> updateBypass(Map<String, String> pinHashes) async {
    _bypassCache = Map.from(pinHashes);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_bypassKey, jsonEncode(_bypassCache));
    print('[PinCache] Bypass updated: ${_bypassCache.length} lockers cached');
    _bypassCache.forEach((id, hash) => print('[PinCache]   bypass locker $id → hash: $hash'));
  }

  /// Returns true if [pin] matches the cached regular PIN hash for [lockerId].
  static bool verify(String lockerId, String pin) {
    final cached = _cache[lockerId];
    if (cached == null) {
      print('[PinCache] verify locker $lockerId — no cache entry');
      return false;
    }
    final hash = sha256.convert(utf8.encode(pin)).toString();
    print('[PinCache] verify locker $lockerId');
    print('[PinCache]   entered PIN  : $pin');
    print('[PinCache]   entered hash : $hash');
    print('[PinCache]   cached  hash : $cached');
    print('[PinCache]   match: ${hash == cached}');
    return hash == cached;
  }

  /// Returns true if [pin] matches the cached bypass PIN hash for [lockerId].
  static bool verifyBypass(String lockerId, String pin) {
    final cached = _bypassCache[lockerId];
    if (cached == null) {
      print('[PinCache] verifyBypass locker $lockerId — no cache entry');
      return false;
    }
    final hash = sha256.convert(utf8.encode(pin)).toString();
    print('[PinCache] verifyBypass locker $lockerId');
    print('[PinCache]   entered hash : $hash');
    print('[PinCache]   cached  hash : $cached');
    print('[PinCache]   match: ${hash == cached}');
    return hash == cached;
  }
}
