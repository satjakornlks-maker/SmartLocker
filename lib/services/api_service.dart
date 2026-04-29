import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/services/device_config_service.dart';
import 'package:untitled/services/pin_cache_service.dart';
import 'package:untitled/services/locker_command_service.dart';
import 'package:untitled/services/offline_status_queue.dart';

// OAuth2 client credentials — client_id is fixed, client_secret comes from
// --dart-define=APP_KEY baked in at build time.
const _clientId = 'flutter-app';

class ApiService {
  late final Dio _dio;

  String? _token;
  DateTime? _tokenExpiry;
  String? _refreshToken;
  DateTime? _refreshTokenExpiry;
  bool _tokensLoaded = false;
  String _lastAuthUrl = '';

  static const _kToken = 'auth_access_token';
  static const _kTokenExp = 'auth_access_expiry';
  static const _kRefresh = 'auth_refresh_token';
  static const _kRefreshExp = 'auth_refresh_expiry';

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: DeviceConfigService.baseUrl.isNotEmpty
            ? DeviceConfigService.baseUrl
            : "http://localhost:5183",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Interceptor: attach Bearer token to every request, refresh on 401
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Keep base URL in sync with runtime config changes
        if (DeviceConfigService.baseUrl.isNotEmpty) {
          _dio.options.baseUrl = DeviceConfigService.baseUrl;
        }
        options.headers['Authorization'] = 'Bearer ${await _getToken()}';
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired — clear cache and retry once with a fresh token
          _token = null;
          _tokenExpiry = null;
          _refreshToken = null;
          _refreshTokenExpiry = null;
          try {
            final opts = error.requestOptions;
            opts.headers['Authorization'] = 'Bearer ${await _getToken()}';
            final response = await _dio.fetch(opts);
            handler.resolve(response);
            return;
          } catch (_) {}
        }
        handler.next(error);
      },
    ));
  }

  Future<void> _loadPersistedTokens() async {
    if (_tokensLoaded) return;
    _tokensLoaded = true;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kToken);
    final tokenExpMs = prefs.getInt(_kTokenExp);
    if (tokenExpMs != null) _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(tokenExpMs);
    _refreshToken = prefs.getString(_kRefresh);
    final refreshExpMs = prefs.getInt(_kRefreshExp);
    if (refreshExpMs != null) _refreshTokenExpiry = DateTime.fromMillisecondsSinceEpoch(refreshExpMs);
  }

  Future<void> _saveTokens(String accessToken, int expiresIn, String refreshToken, int refreshExpiresIn) async {
    _token = accessToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn - 60));
    _refreshToken = refreshToken;
    _refreshTokenExpiry = DateTime.now().add(Duration(seconds: refreshExpiresIn - 300));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, _token!);
    await prefs.setInt(_kTokenExp, _tokenExpiry!.millisecondsSinceEpoch);
    await prefs.setString(_kRefresh, _refreshToken!);
    await prefs.setInt(_kRefreshExp, _refreshTokenExpiry!.millisecondsSinceEpoch);
  }

  Future<String> _getToken() async {
    // If the base URL changed since last auth, clear all in-memory tokens so
    // we re-authenticate against the new server instead of sending old ones.
    final currentUrl = _dio.options.baseUrl;
    if (_lastAuthUrl.isNotEmpty && _lastAuthUrl != currentUrl) {
      _token = null;
      _tokenExpiry = null;
      _refreshToken = null;
      _refreshTokenExpiry = null;
      _tokensLoaded = false;
    }
    _lastAuthUrl = currentUrl;

    await _loadPersistedTokens();

    // 1. Access token still valid
    if (_token != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!)) {
      return _token!;
    }

    // 2. Refresh token still valid — use it to get a new pair
    if (_refreshToken != null && _refreshTokenExpiry != null && DateTime.now().isBefore(_refreshTokenExpiry!)) {
      try {
        final resp = await Dio().post(
          '${_dio.options.baseUrl}/auth/refresh',
          data: {'refresh_token': _refreshToken},
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        await _saveTokens(
          resp.data['access_token'] as String,
          resp.data['expires_in'] as int? ?? 900,
          resp.data['refresh_token'] as String,
          resp.data['refresh_expires_in'] as int? ?? 604800,
        );
        debugPrint('[ApiService] Token refreshed via refresh_token');
        return _token!;
      } catch (e) {
        debugPrint('[ApiService] Refresh failed, falling back to full auth: $e');
        _refreshToken = null;
        _refreshTokenExpiry = null;
      }
    }

    // 3. Full re-auth with client secret
    final clientSecret = DeviceConfigService.appKey;
    if (clientSecret.isEmpty) {
      debugPrint('[ApiService] ERROR: APP_KEY not configured — cannot authenticate');
      throw StateError('Missing APP_KEY. Build with --dart-define=APP_KEY=...');
    }
    try {
      final resp = await Dio().post(
        '${_dio.options.baseUrl}/auth/token',
        data: {'client_id': _clientId, 'client_secret': clientSecret},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      await _saveTokens(
        resp.data['access_token'] as String,
        resp.data['expires_in'] as int? ?? 900,
        resp.data['refresh_token'] as String,
        resp.data['refresh_expires_in'] as int? ?? 604800,
      );
      debugPrint('[ApiService] Token acquired via client credentials');
      return _token!;
    } catch (e) {
      debugPrint('[ApiService] Token fetch failed: $e');
      return '';
    }
  }

  /// Registers the device on first launch, or fetches its current config on
  /// subsequent launches. The backend should handle both cases (upsert).
  ///
  /// Expected response:
  /// { "base_url": "http://...", "locker_ids": [1, 2, 3], "assigned_locker": 1 }
  Future<Map<String, dynamic>> syncDeviceConfig(String deviceId) async {
    try {
      final response = await _dio.post(
        '/device/register',
        data: {'device_id': deviceId},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  /// Fetches SHA-256 hashed PINs (regular + bypass) for all assigned lockers and caches them locally.
  /// Silently fails if offline — existing cache is used.
  Future<void> syncPinCache() async {
    try {
      final response = await _dio.post(
        '/init/get_locker_pins',
        data: {'locker_ids': DeviceConfigService.lockerIds},
      );
      debugPrint('[ApiService] Raw PIN cache response: ${response.data}');
      final responseMap = response.data as Map;

      // Support both old flat format { lockerId: hash } and new { pins: {}, bypass_pins: {} }
      if (responseMap.containsKey('pins')) {
        final pins = Map<String, String>.from(
          (responseMap['pins'] as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
        );
        await PinCacheService.update(pins);

        final bypassPins = responseMap['bypass_pins'] as Map? ?? {};
        final bypass = Map<String, String>.from(
          bypassPins.map((k, v) => MapEntry(k.toString(), v.toString())),
        );
        await PinCacheService.updateBypass(bypass);
      } else {
        // Legacy flat format
        final data = Map<String, String>.from(
          responseMap.map((k, v) => MapEntry(k.toString(), v.toString())),
        );
        await PinCacheService.update(data);
      }
    } catch (e) {
      debugPrint('[ApiService] PIN cache sync failed (using cached): $e');
    }
  }

  /// Replays /unlock_locker calls that were queued while the backend was offline.
  /// On success the backend clears the booking, so the locker UI turns green.
  Future<void> flushOfflineQueue() async {
    await OfflineStatusQueue.flush((lockerUnitId, pin, stillUse, timestamp) async {
      try {
        final response = await _dio.post('/unlock_locker', data: {
          'LockerUnitID': lockerUnitId,
          'pin':          pin,
          'stillUse':     stillUse,
          'timestamp':    timestamp,
          'skipHardware': true, // locker already physically unlocked offline
        });
        return response.statusCode == 200;
      } catch (_) {
        return false;
      }
    });
  }

  /// Marks the device as offline in the backend. Call on app shutdown.
  Future<Map<String, dynamic>> setDeviceOffline(String deviceId) async {
    try {
      final response = await _dio.post(
        '/device/offline',
        data: {'device_id': deviceId},
      );
      return {'success': true, 'data': response.data};
    } on DioException catch (e) {
      return {'success': false, 'error': _handleError(e)};
    }
  }

  /// Fetches available locker sizes with bilingual labels from the backend.
  Future<List<Map<String, dynamic>>> getSizes() async {
    final response = await _dio.get('/init/get_sizes');
    final data = response.data;
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  /// Sends a health ping to the backend so it knows this device is still alive.
  /// Returns the response data (includes locker_ids, assigned_locker, system_mode)
  /// so the caller can sync config, or null if the ping failed.
  /// Called periodically by DeviceHeartbeatService.
  Future<Map<String, dynamic>?> pingHealth(String deviceId) async {
    try {
      final response = await _dio.post(
        '/app_device/ping',
        data: {'DeviceId': deviceId},
      );
      return response.data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }


  Future<Map<String,dynamic>> regisAccount(String name,String tel,String email,String reason) async {
    List<String> stringList = name.split(RegExp(r' '));

    try{
      final response = await _dio.post(
          '/locker/periodic_request',
          data: {
            'PhoneNumber':tel,
            'Email':email,
            'Reason':reason,
            'FromDatetime' : DateTime.now().toString(),
            'ToDatetime': DateTime.now().toString(),
            'BookedTypeId': 3,
            'Name':stringList[0],
            if(stringList.length > 1)
            'Lastname':stringList[1]
          }
      );
      return{
        'success':true,
        'data':response.data,
      };

    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> sendOTP(String data,bool isEmail,String lockerId,bool isVisitor) async {
    late String type;
    if(isEmail){
     type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final response = await _dio.post(
          '/locker/send_otp',
          data: {
            'LockerUnitID':int.parse(lockerId),
            type: data,
            "BookedTypeId": isVisitor ? 5 : 1,
          }

      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e),
        if (e.response?.statusCode != null) 'statusCode': e.response!.statusCode,
      };
    }
  }

  Future<Map<String,dynamic>> sendLink(String data,bool isEmail,String lockerId,bool isVisitor) async {
    late String type;
    if(isEmail){
      type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final response = await _dio.post(
          '/send-link',
          data: {
            'LockerUnitID':int.parse(lockerId),
            type: data,
            "BookedTypeId": isVisitor ? 5 : 1,
          }

      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> bookLocker(bool isEmail,String telOrEmail,String lockerId ,String pin,DateTime? toDateTime,int userId, bool isVisitor) async {
    late String type;
    if(isEmail){
      type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final response = await _dio.post(
        '/locker/register',
        data: {
          'userId':userId,
          'LockerUnitID':lockerId,
          //'name': name,
          type:telOrEmail,
          //'reason':reason,
          'FromDatetime' : DateTime.now().toString(),
          'ToDatetime': toDateTime.toString(),
          'BookedTypeId': isVisitor ? 5:1,

        }
      );
      Future.delayed(const Duration(seconds: 3), () => syncPinCache().ignore());
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleEmergency(String lockerId) async {
    try{
      final response = await _dio.post(
          '/locker/emergency_unlock',
          data: {
            'LockerUnitID': int.parse(lockerId),
          }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  static const _lockerCacheKey = 'locker_cache';

  Future<Map<String, dynamic>> getLocker() async {
    final lockerIds = DeviceConfigService.lockerIds;
    try {
      final response = await _dio.post(
        '/init/get_locker',
        data: lockerIds,
      );
      // Persist for offline use
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lockerCacheKey, jsonEncode(response.data));
      return {
        'success': true,
        'data': response.data
      };
    } on DioException catch (e) {
      if (_isOffline(e)) {
        final prefs = await SharedPreferences.getInstance();
        final cached = prefs.getString(_lockerCacheKey);
        if (cached != null) {
          debugPrint('[ApiService] Offline — returning cached locker data');
          return {'success': true, 'data': jsonDecode(cached), 'offline': true};
        }
        return {'success': false, 'offline': true};
      }
      return {
        'success': false,
        'error': _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> getPendingUser()async{
    try{
      final response = await _dio.get('/init/get_pending_user');
      return{
        'success':true,
        'data':response.data
      };
    }on DioException catch (e){
      return{
        'success': false,
        'error': _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleResetPassword(int userId,String newPIN) async{
    try{
      final response = await _dio.post(
          '/reset_password',
          data: {
            'userID': userId,
            'newPIN': newPIN,
            'timestamp' : DateTime.now().toIso8601String(),
          }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch(e){
      return{
        'success':false,
        'error': _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleForgotPassword(String data, bool isEmail,String? lockerId ) async{
    late String type;
    if(isEmail){
      type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final response = await _dio.post(
          '/forgot_password',
          data: {
            type: data,
            if(lockerId != null)
            'LockerUnitId' : int.parse(lockerId)
          }
      );
      // Delay 10s to let backend finish setting the new PIN before caching
      Future.delayed(const Duration(seconds: 3), () => syncPinCache().ignore());
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleSubmitOTP(String data,String otp,bool isEmail)async{
    late String type;
    if(isEmail){
      type = 'email';
    }else{
      type = 'phone_number';
    }

    try{
      final response = await _dio.post(
          '/locker/verify',
          data: {
            type: data,
            'pin':otp,
          }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String, dynamic>> handleFillPIN({
    required String pin,
    required String lockerId,
    bool stillUse = true,
  }) async {
    try {
      final response = await _dio.post(
        '/unlock_locker',
        data: {
          'LockerUnitID': int.parse(lockerId),
          'pin': pin,
          'stillUse': stillUse,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      Future.delayed(const Duration(seconds: 3), () => syncPinCache().ignore());
      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      if (_isOffline(e)) {
        // Offline: verify PIN locally before sending hardware unlock command.
        final pinValid = PinCacheService.verify(lockerId, pin) ||
            PinCacheService.verifyBypass(lockerId, pin);
        if (!pinValid) {
          debugPrint('[ApiService] Offline unlock locker $lockerId: PIN verification failed');
          return {'success': false, 'offline': true, 'data': {}};
        }
        // PIN verified — send unlock command directly to the HF converter via TCP.
        final ok = await LockerCommandService.unlockImmediate(lockerId);
        debugPrint('[ApiService] Offline unlock locker $lockerId: ${ok ? 'OK' : 'FAIL'}');
        if (ok) {
          // Queue the /unlock_locker call so the locker turns green when backend returns.
          OfflineStatusQueue.add(
            lockerId: lockerId,
            pin:      pin,
            stillUse: stillUse,
          ).ignore();
        }
        return {'success': ok, 'offline': true, 'data': {}};
      }
      return {
        'success': false,
        'error': _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleAcceptRequest(int userId)async{
    try{
      final response = await _dio.post(
          '/approve/accept',
          data: {
            'userId':userId,
            'ToDatetime': DateTime.now().add(Duration(days: 365 * 10)).toString(),
          }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleRejectRequest(int userId)async{
    try{
      final response = await _dio.post(
          '/approve/reject',
          data: {
            'userId':userId,
            }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleCheckLockerStatus(String lockerId)async{
    try{
      final response = await _dio.post(
          '/locker/status',
          data: {
            'LockerID': DeviceConfigService.assignedLocker,
            'LockerUnitID': int.parse(lockerId),
          }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleCheckOTP(String lockerId,String pin)async{
    try{
      final response = await _dio.post(
        '/verify_pin',
        data: {
          'pin' : pin,
          'LockerUnitID' : lockerId
        }
      );
      return{
        'success':true,
        'data':response.data,
      };
    }on DioException catch (e){
      if (_isOffline(e)) {
        final ok = PinCacheService.verify(lockerId, pin) ||
                   PinCacheService.verifyBypass(lockerId, pin);
        debugPrint('[ApiService] Offline PIN verify locker $lockerId: ${ok ? 'OK' : 'FAIL'}');
        return {'success': ok, 'offline': true, 'data': {}};
      }
      return{
        'success':false,
        'error':_handleError(e)
      };
    }
  }

  /// Returns true when the error means the backend is unreachable —
  /// either no connection, a timeout, or the proxy returning 503.
  static bool _isOffline(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) return true;
    if (e.type == DioExceptionType.badResponse &&
        e.response?.statusCode == 503) return true;
    return false;
  }

  String _handleError(DioException e) {

    debugPrint('============ DIO ERROR DEBUG ============');
    debugPrint('Error Type: ${e.type}');
    debugPrint('Error Message: ${e.message}');
    debugPrint('Status Code: ${e.response?.statusCode}');
    debugPrint('Response Data: ${e.response?.data}');
    debugPrint('Request URL: ${e.requestOptions.uri}');
    debugPrint('Request Method: ${e.requestOptions.method}');
    debugPrint('Request Data: ${e.requestOptions.data}');
    debugPrint('========================================');
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout - เซิร์ฟเวอร์ไม่ตอบสนอง';

      case DioExceptionType.sendTimeout:
        return 'Send timeout - ส่งข้อมูลช้าเกินไป';

      case DioExceptionType.receiveTimeout:
        return 'Receive timeout - รับข้อมูลช้าเกินไป';

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;

        // Try to extract backend error message
        String errorMsg = 'Server error';
        if (data != null) {
          if (data is Map) {
            errorMsg = data['message'] ?? data['error'] ?? data['Message'] ?? data.toString();
          } else if (data is String) {
            errorMsg = data;
          }
        }
        return '[$statusCode] $errorMsg';

      case DioExceptionType.cancel:
        return 'Request cancelled';

      case DioExceptionType.connectionError:
        return 'Cannot connect: ${e.message}\nCheck: 1) Server running 2) Correct IP 3) Network connection';

      case DioExceptionType.badCertificate:
        return 'SSL Certificate error - ใช้ HTTP หรือติดตั้ง certificate';

      case DioExceptionType.unknown:
        return 'Unknown error: ${e.message ?? e.error.toString()}';

      }
  }


}


