import 'package:dio/dio.dart';
import 'package:task_me_flutter/domain/models/api_response.dart';
import 'package:task_me_flutter/domain/models/schemes.dart';
import 'dart:convert';

part 'auth.dart';
part 'interval.dart';
part 'project.dart';
part 'task.dart';
part 'user.dart';

class ApiRepository {
  final String? token;
  final String url;

  const ApiRepository({
    this.token,
    required this.url,
  });

  Dio get client => Dio(
        BaseOptions(
          baseUrl: url,
          headers: token != null ? {'Authorization': token} : null,
          followRedirects: false,
        ),
      );
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
