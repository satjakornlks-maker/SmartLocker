import 'package:dio/dio.dart';


class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://localhost:44324',
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      headers: {
        'Content-Type' : 'application/json'
      }
    )
  );


  Future<Map<String,dynamic>> regisAccount(String name,String tel,String email,String reason,String lockerId) async {
    int lockerId = 2;
    print(DateTime.now().toIso8601String());
    try{
      final responss = await _dio.post(
          '/locker/register',
          data: {
            'LockerUnitID':lockerId,
            //'name': name,
            'PhoneNumber':tel,
            'Email':email,
            //'reason':reason,
            'FromDatetime' : DateTime.now().toString(),
            'ToDatetime': DateTime.now().toString(),
            'BookedTypeId': 3
          }
      );
      print('Response data: ${responss.data}');
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

  Future<Map<String,dynamic>> sendOTP(String data,bool isEmail ) async {
    late String type;
    if(isEmail){
     type = 'Email';
    }else{
      type = 'PhoneNumber';
    }

    try{
      final responss = await _dio.post(
          '/send_otp',
          data: {
            type: data,
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

  Future<Map<String,dynamic>> bookLocker(String lockerId ,String pin,) async {
    try{
      final responss = await _dio.post(
        '/post',
        data: {
          'pin' : pin,
          'lockerId': int.parse(lockerId),
          'FromDatetime' : DateTime.now().toString(),
          'ToDatetime': DateTime.now().toString(),
          'BookedTypeId': 1
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

  Future<Map<String,dynamic>> handleResetPassword(String oldPIN,String newPIN) async{
    try{
      final response = await _dio.post(
          '/post',
          data: {
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

  Future<Map<String,dynamic>> handleForgotPassword(String data, bool isEmail) async{
    late String type;
    if(isEmail){
      type = 'validateEmail';
    }else{
      type = 'validateTel';
    }

    try{
      final responss = await _dio.post(
          '/post',
          data: {
            type: data,
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

  Future<Map<String,dynamic>> handleSubmitOTP(String data,String OTP,bool isEmail)async{
    late String type;
    if(isEmail){
      type = 'validateEmail';
    }else{
      type = 'validateTel';
    }

    try{
      final responss = await _dio.post(
          '/post',
          data: {
            type: data,
            'otp':OTP,
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

  Future<Map<String,dynamic>> handleFillPIN(String PIN)async{
    try{
      final responss = await _dio.post(
          '/post',
          data: {

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

  String _handleError(DioException e) {
    print('═══ ERROR DEBUG ═══');
    print('Type: ${e.type}');
    print('Message: ${e.message}');
    print('Status Code: ${e.response?.statusCode}');
    print('Response Data: ${e.response?.data}');
    print('Error: ${e.error}');
    print('═══════════════════');

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

      default:
        return 'Error: ${e.message ?? e.error?.toString() ?? "Unknown"}';
    }
  }


}


