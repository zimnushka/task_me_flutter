import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/models/schemes.dart';
import 'package:task_me_flutter/layers/repositories/session/session.dart';

class UserApiRepository {
  static Dio client = Dio(BaseOptions(
    baseUrl: 'http://192.168.17.9:8080/user',
    connectTimeout: 10000,
  ));

  Future<ApiResponse<User?>> getUserMe(Session session) async {
    final data = await client.get('/me', options: Options(headers: session.sign()));
    if (ApiResponse.isSuccessStatusCode(data.statusCode ?? 0)) {
      return ApiResponse(
          data: User.fromJson(jsonDecode(data.data as String)),
          isSuccess: true,
          message: null,
          statusCode: data.statusCode!);
    }
    return ApiResponse(
        data: null, isSuccess: false, message: data.data, statusCode: data.statusCode ?? 0);
  }
}
