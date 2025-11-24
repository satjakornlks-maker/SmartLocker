import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://httpbin.org',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type' : 'application/json'
      }
    )
  );

  Future<Map<String,dynamic>> regisAccount(String name,String tel,String email,String reason) async {
    try{
      final responss = await _dio.post(
          '/post',
          data: {
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

  Future<Map<String,dynamic>> sendOTP(String tel ) async {
    try{
      final responss = await _dio.post(
          '/post',
          data: {
            'tel': tel,
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


