import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://localhost:44324/",
        // baseUrl: "http://10.3.0.4:8097",
        // use for prod
        // baseUrl: String.fromEnvironment("BASE_URL")??'default_url',  // ไม่มี /api
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {
          // 'Content-Type': 'application/json',
          'X-API-KEY': 'X0W8Id76MYiAf2J7vlgSQkOUL3Em4UkvlIC5J5w6ozQ=',
          //for prod
          // 'X-API-KEY': String.fromEnvironment("API_KEY")
        },
      ),
    );

    // _dio.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () {
    //     final client = HttpClient();
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //     return client;
    //   },
    // );
  }


  Future<Map<String,dynamic>> regisAccount(String name,String tel,String email,String reason,String lockerId) async {
    List<String> stringList = name.split(RegExp(r' '));

    try{
      final responss = await _dio.post(
          '/locker/periodic_request',
          data: {
            'LockerUnitID':int.parse(lockerId),
            // 'Name': stringList,
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
        'data':responss.data,
      };

    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> sendOTP(String data,bool isEmail,String lockerId) async {
    late String type;
    if(isEmail){
     type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final responss = await _dio.post(
          '/locker/send_otp',
          data: {
            'LockerUnitID':int.parse(lockerId),
            type: data,
            "BookedTypeId": 1,
          }
      );
      return{
        'success':true,
        'data':responss.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> bookLocker(bool isEmail,String telOrEmail,String lockerId ,String pin,DateTime toDateTime,int userId) async {
    late String type;
    if(isEmail){
      type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final responss = await _dio.post(
        '/locker/register',
        data: {
          'userId':userId,
          'LockerUnitID':lockerId,
          //'name': name,
          type:telOrEmail,
          //'reason':reason,
          'FromDatetime' : DateTime.now().toString(),
          'ToDatetime': toDateTime.toString(),
          'BookedTypeId': 1,

        }
      );
      return{
        'success':true,
        'data':responss.data,
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

  Future<Map<String,dynamic>> getLocker()async{
    try{
      final response = await _dio.get('/init/get_locker');
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

  Future<Map<String,dynamic>> handleResetPassword(String oldPIN,String newPIN,String tel) async{
    try{
      final response = await _dio.post(
          '/reset_password',
          data: {
            'tel': tel,
            'oldPIN': oldPIN,
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
      final responss = await _dio.post(
          '/forgot_password',
          data: {
            type: data,
            if(lockerId != null)
            'LockerUnitId' : int.parse(lockerId)
          }
      );
      return{
        'success':true,
        'data':responss.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleSubmitOTP(String data,String OTP,bool isEmail)async{
    late String type;
    if(isEmail){
      type = 'email';
    }else{
      type = 'phone_number';
    }

    try{
      final responss = await _dio.post(
          '/locker/verify',
          data: {
            type: data,
            'pin':OTP,
          }
      );
      return{
        'success':true,
        'data':responss.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleFillPIN(String PIN,String lockerId)async{
    try{
      final responss = await _dio.post(
          '/unlock_locker',
          data: {
            'LockerUnitID': int.parse(lockerId),
            'pin':PIN,
            'timestamp' : DateTime.now().toIso8601String(),
          }
      );
      return{
        'success':true,
        'data':responss.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  Future<Map<String,dynamic>> handleAcceptRequest(int userId)async{
    try{
      final responss = await _dio.post(
          '/approve/accept',
          data: {
            'userId':userId,
            'ToDatetime': DateTime.now().add(Duration(days: 365 * 10)).toString(),
          }
      );
      return{
        'success':true,
        'data':responss.data,
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
      final responss = await _dio.post(
          '/approve/reject',
          data: {
            'userId':userId,
            }
      );
      return{
        'success':true,
        'data':responss.data,
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
      final responss = await _dio.post(
          '/locker/status',
          data: {
            'LockerID': 1,
            'LockerUnitID': int.parse(lockerId),
          }
      );
      return{
        'success':true,
        'data':responss.data,
      };
    }on DioException catch (e){
      return{
        'success' : false,
        'error' : _handleError(e)
      };
    }
  }

  String _handleError(DioException e) {

    print('============ DIO ERROR DEBUG ============');
    print('Error Type: ${e.type}');
    print('Error Message: ${e.message}');
    print('Status Code: ${e.response?.statusCode}');
    print('Response Data: ${e.response?.data}');
    print('Request URL: ${e.requestOptions.uri}');
    print('Request Method: ${e.requestOptions.method}');
    print('Request Data: ${e.requestOptions.data}');
    print('========================================');
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


