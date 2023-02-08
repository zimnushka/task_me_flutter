import 'package:dio/dio.dart';

class ApiResponse<T> {
  final int statusCode;
  final bool isSuccess;
  final String? message;
  final T? data;

  static bool isSuccessStatusCode(int? code) {
    final index = code ?? 0;
    return index > 199 && index < 300;
  }

  factory ApiResponse({T? body, int? status, Exception? error}) {
    // ignore: avoid_bool_literals_in_conditional_expressions
    final isSuccess = error != null ? false : isSuccessStatusCode(status);
    String message = error.toString();
    if (error is DioError) {
      message = error.response?.data.toString() ?? error.message;
    }
    return ApiResponse._internal(
      data: isSuccess ? body : null,
      isSuccess: isSuccess,
      message: isSuccess ? null : message,
      statusCode: status ?? 0,
    );
  }

  ApiResponse._internal({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.statusCode,
  });

  // const ApiResponse({
  // required this.data,
  // required this.isSuccess,
  // required this.message,
  // required this.statusCode,
  // });
}
