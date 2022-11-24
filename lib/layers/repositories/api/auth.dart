import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';

class AuthApiRepository {
  static Dio client = Dio(BaseOptions(
    baseUrl: 'http://192.168.17.9:8080/auth',
    connectTimeout: 10000,
  ));

  Future<ApiResponse<String?>> login(String email, String password) async {
    final data = await client.post('/login', data: {'email': email, 'password': password});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<String?>> registration(String email, String password, String name) async {
    final data = await client
        .post('/registration', data: {'email': email, 'password': password, 'name': name});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
