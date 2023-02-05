import 'package:dio/dio.dart';
import 'package:task_me_flutter/layers/models/api_response.dart';
import 'package:task_me_flutter/layers/repositories/session/session.dart';

abstract class ApiRepository {
  static Session? _session;
  static String? _url;
  static Dio _dio = Dio();

  static set session(Session value) => _setSession(value);
  static set url(String value) => _setUrl(value);

  final unexpectedError = ApiResponse(body: 'unexpected error', status: 0);

  static _setUrl(String value) {
    _url = value;
    _updateDio();
  }

  static _setSession(Session value) {
    _session = value;
    _updateDio();
  }

  static _updateDio() {
    _dio = Dio(BaseOptions(
      baseUrl: _url ?? '',
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

  Dio get client => _dio;
}
