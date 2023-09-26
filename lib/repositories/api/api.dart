import 'package:dio/dio.dart';
import 'package:task_me_flutter/domain/models/api_response.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'package:task_me_flutter/repositories/session/session.dart';

abstract class ApiRepository {
  static Session? _session;
  static String? _url;
  static Dio _dio = Dio();

  static set session(Session value) => _setSession(value);
  static set url(String value) => _setUrl(value);

  static void setConfig(Config value) {
    _url = value.apiBaseUrl;
    _updateDio();
  }

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
      headers: _session?.sign(),
      followRedirects: false,
    ));
  }

  Dio get client => _dio;
}

class ApiErrorHandler<T> {
  final Future<ApiResponse<T?>> Function() func;
  const ApiErrorHandler(this.func);

  Future<ApiResponse<T?>> get result => _errorHandler();

  Future<ApiResponse<T?>> _errorHandler() async {
    try {
      final result = await func();
      return result;
    } on DioError catch (e) {
      return ApiResponse<T?>(body: null, status: e.response?.statusCode ?? 0, error: e);
    } catch (e) {
      return ApiResponse<T?>(body: null, status: 0, error: Exception(e.toString()));
    }
  }
}