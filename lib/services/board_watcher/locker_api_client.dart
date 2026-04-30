// lib/services/board_watcher/locker_api_client.dart
// All backend HTTP communication for the board watcher:
//   - HF config resolution (API fetch / env override)
//   - Locker data fetch and mapping
//   - Locker status update / offline notify / sync
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'dart:io';

import 'hf_connection.dart';

String _ts() {
  final n = DateTime.now();
  return '${n.hour.toString().padLeft(2, '0')}:'
      '${n.minute.toString().padLeft(2, '0')}:'
      '${n.second.toString().padLeft(2, '0')}.'
      '${n.millisecond.toString().padLeft(3, '0')}';
}

class LockerApiClient {
  final String apiBaseUrl;
  final int assignedLocker;
  final String hfConnectionsOverride;
  final Map<String, String> headers;

  const LockerApiClient({
    required this.apiBaseUrl,
    required this.assignedLocker,
    required this.hfConnectionsOverride,
    required this.headers,
  });

  // ---- Low-level HTTP ----

  Future<Map<String, dynamic>?> httpPost(
      String url, Map<String, dynamic> body) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final req = await client
          .postUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 10));
      // Use bytes + explicit Content-Length to avoid chunked encoding,
      // which IIS/.NET 4.7 can hang waiting for.
      final bodyBytes = utf8.encode(jsonEncode(body));
      req.headers.contentType = ContentType.json;
      req.headers.contentLength = bodyBytes.length;
      headers.forEach((k, v) => req.headers.set(k, v));
      req.add(bodyBytes);
      final res = await req.close().timeout(const Duration(seconds: 10));
      final text = await res.transform(utf8.decoder).join();
      if (res.statusCode == 200) {
        try {
          return jsonDecode(text) as Map<String, dynamic>;
        } catch (_) {
          return {'_text': text};
        }
      }
      debugPrint('[${_ts()}] HTTP POST $url → ${res.statusCode}');
      return null;
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<dynamic> httpGet(String url) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 5);
    try {
      final req = await client
          .getUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 5));
      headers.forEach((k, v) => req.headers.set(k, v));
      final res = await req.close().timeout(const Duration(seconds: 5));
      final text = await res.transform(utf8.decoder).join();
      if (res.statusCode == 200) return jsonDecode(text);
      debugPrint('[${_ts()}] HTTP GET $url → ${res.statusCode}');
      return null;
    } catch (e) {
      rethrow;
    } finally {
      client.close();
    }
  }

  // ---- HF config ----

  Future<List<HFConnection>> _fetchHfConfig() async {
    if (assignedLocker <= 0) {
      debugPrint('[${_ts()}] WARN: assignedLocker not set (value=$assignedLocker) — no HF connections');
      return [];
    }
    try {
      final data = await httpPost('$apiBaseUrl/init/get_HF_config', {'locker_id': assignedLocker});
      if (data != null) {
        final ip    = data['hf_ip'] as String;
        final port  = (data['hf_port'] as num).toInt();
        final addrs = (data['cu_addresses'] as List).cast<String>().join(',');
        final conn  = HFConnection(ip, port, parseCuAddresses(addrs));
        debugPrint('[${_ts()}] Loaded HF config from API: $conn');
        return [conn];
      }
      debugPrint('[${_ts()}] WARN: HF config API returned no data — no HF connections');
    } catch (e) {
      debugPrint('[${_ts()}] WARN: Could not fetch HF config ($e) — no HF connections');
    }
    return [];
  }

  Future<List<HFConnection>> resolveHfConnections() async {
    if (hfConnectionsOverride.isNotEmpty) {
      final list = <HFConnection>[];
      for (final entry in hfConnectionsOverride.split(';')) {
        final e = entry.trim();
        if (e.isEmpty) continue;
        final parts = e.split(':');
        if (parts.length < 3) {
          debugPrint('WARN: Invalid HF_CONNECTIONS entry: "$e"');
          continue;
        }
        list.add(HFConnection(
          parts[0].trim(),
          int.parse(parts[1].trim()),
          parseCuAddresses(parts[2].trim()),
        ));
      }
      if (list.isNotEmpty) return list;
    }
    return _fetchHfConfig();
  }

  // ---- Locker data ----

  Future<dynamic> fetchLockerData() async {
    try {
      final data = await httpGet('$apiBaseUrl/init/get_all_locker_unit');
      debugPrint('[${_ts()}] API GET locker data: OK');
      return data;
    } catch (e) {
      debugPrint('[${_ts()}] API GET locker data error: $e');
      return null;
    }
  }

  static Map<int, Map<int, Map<String, dynamic>>> buildLockerMapForAllCus(
      dynamic apiData, List<int> cuAddresses) {
    final lockers = apiData is List
        ? apiData.cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    final result = <int, Map<int, Map<String, dynamic>>>{};

    for (final cuAddr in cuAddresses) {
      final cuCode = '0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}';
      final map    = <int, Map<String, dynamic>>{};
      for (final locker in lockers) {
        final code = locker['cuCode'] as String?;
        if (code == cuCode) {
          final ch = locker['cuNumber'];
          if (ch != null) map[int.parse(ch.toString())] = Map.from(locker);
        }
      }
      result[cuAddr] = map;
      debugPrint('[${DateTime.now()}] Loaded ${map.length} lockers for CU $cuCode');
    }
    return result;
  }

  // ---- Status updates ----

  Future<bool> updateLockerStatus(
    int lockerUnitId,
    String status,
    bool occupied, {
    String? cuCode,
    String? alertType,
    String? alertMessage,
  }) async {
    try {
      final result = await httpPost('$apiBaseUrl/Locker_status_update', {
        'LockerUnitID': lockerUnitId,
        'enable':       true,
        'status':       status,
        'cuStatus':     true,
        'has_item':     occupied,
        'CU_code':      cuCode,
        'type':         alertType,
        'message':      alertMessage,
        'is_read':      false,
      });
      return result != null;
    } catch (e) {
      debugPrint('[${_ts()}] updateLockerStatus error: $e');
      return false;
    }
  }

  Future<void> notifyBoardOffline(
    Map<int, Map<String, dynamic>> lockerMap,
    int cuAddr, {
    String? alertType,
    String? alertMessage,
  }) async {
    final hex = '0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}';
    if (lockerMap.isEmpty) {
      debugPrint('[${_ts()}] WARN: No locker map for CU $hex, cannot notify offline');
      return;
    }
    for (final entry in lockerMap.entries) {
      final locker     = entry.value;
      final lockerUId  = locker['id'];
      final lockerName = locker['name'] ?? 'CU$hex-CH${entry.key}';
      try {
        await httpPost('$apiBaseUrl/Locker_status_update', {
          'LockerUnitID': lockerUId,
          'CU_code':      hex,
          'enable':       false,
          'cuStatus':     false,
          'has_item':     locker['has_item'] ?? false,
          'type':         alertType,
          'message':      alertMessage,
          'is_read':      false,
        });
        debugPrint('[${_ts()}] API: $lockerName (ID:$lockerUId) reported OFFLINE');
      } catch (e) {
        debugPrint('[${_ts()}] API offline report error for $lockerName: $e');
      }
    }
  }

  Future<void> syncStatusToApi(
    Map<int, Map<String, dynamic>> lockerMap,
    int cuAddr,
    int ch,
    int irValue,
    int lockValue,
  ) async {
    if (!lockerMap.containsKey(ch)) return;
    final locker    = lockerMap[ch]!;
    final lockerUId = locker['id'] as int;
    final hex       = '0x${cuAddr.toRadixString(16).padLeft(2, '0').toUpperCase()}';
    final name      = locker['name'] as String? ?? 'CU$hex-CH$ch';
    final occupied  = irValue == 1;
    final newStatus = lockValue == 0 ? 'open' : 'close';
    final dbStatus   = locker['_synced_status']   as String? ?? '';
    final dbOccupied = locker['_synced_occupied'] as bool?;   // null = never synced

    final statusChanged   = newStatus != dbStatus;
    final occupiedChanged = dbOccupied == null || occupied != dbOccupied;

    if (statusChanged || occupiedChanged) {
      final ok = await updateLockerStatus(lockerUId, newStatus, occupied, cuCode: hex);
      if (ok) {
        debugPrint('[${_ts()}] API: $name (ID:$lockerUId) -> $newStatus, has_item=$occupied');
        locker['_synced_status']   = newStatus;
        locker['_synced_occupied'] = occupied;
      }
    }
  }
}
