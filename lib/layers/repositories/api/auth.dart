import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/repositories/api/api.dart';

class AuthApiRepository extends ApiRepository {
  Future<ApiResponse<String?>> login(String email, String password) async {
    final data = await client.post('/auth/login', data: {'email': email, 'password': password});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }

  Future<ApiResponse<String?>> registration(String email, String password, String name) async {
    final data = await client
        .post('/auth/registration', data: {'email': email, 'password': password, 'name': name});
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: data.data as String, isSuccess: true, message: null, statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
