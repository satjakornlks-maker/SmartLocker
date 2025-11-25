import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://httpbin.org',
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
      headers: {
        'Content-Type' : 'application/json'
      }
    )
  );

  Future<Map<String,dynamic>> regisAccount(String name,String tel,String email,String reason,String lockerId) async {
    try{
      final responss = await _dio.post(
          '/post',
          data: {
            'lockerId':lockerId,
            'name': name,
            'tel':tel,
            'email':email,
            'reason':reason,
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

  Future<Map<String,dynamic>> sendOTP(String data,bool isEmail ) async {
    late String type;
    if(isEmail){
     type = 'email';
    }else{
      type = 'tel';
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

  Future<Map<String,dynamic>> bookLocker(String lockerId ,String pin,String type) async {
    try{
      final responss = await _dio.post(
        '/post',
        data: {
          'pin' : pin,
          'lockerId': lockerId,
          'timestamp' : DateTime.now().toIso8601String(),
          'type' : type
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

  Future<Map<String,dynamic>> handleEmergency(String lockerId, String order) async {
    try{
      final response = await _dio.post(
          '/post',
          data: {
            'lockerId': lockerId,
            'timestamp' : DateTime.now().toIso8601String(),
            'status': order,
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

  Future<Map<String,dynamic>> getLockerStatus(String lockerId)async{
    try{
      final response = await _dio.get('');
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

  String _handleError(DioException e){
    switch (e.type){
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error';
    }
  }
}


