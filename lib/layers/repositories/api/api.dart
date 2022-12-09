import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/repositories/session/session.dart';

abstract class ApiRepository {
  static Session? _session;

  static set session(Session value) => _session = value;

  Dio get client {
    log('Get DIO client');
    return Dio(BaseOptions(
      baseUrl: 'http://192.168.17.9:8080',
      connectTimeout: 10000,
      headers: _session?.sign(),
      followRedirects: false,
    ))
      ..interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseHeader: true,
          requestBody: true,
          responseBody: true,
          error: false,
        ),
      );
  }

  // Future<ApiResponse> get(String url) async {
  //   try {
  //     final data = await client.get(url);
  //     return ApiResponse(data: data.data,isSuccess: ApiResponse.isSuccessStatusCode(data.statusCode??0), message: null,statusCode: data.statusCode);
  //   } catch (e) {}
  // }
}
