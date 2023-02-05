class ApiResponse<T> {
  final int statusCode;
  final bool isSuccess;
  final String? message;
  final T data;

  static bool isSuccessStatusCode(int? code) {
    final index = code ?? 0;
    return index > 199 && index < 300;
  }

  factory ApiResponse({required T body, int? status}) {
    final isSuccess = isSuccessStatusCode(status);
    return ApiResponse._internal(
      data: body,
      isSuccess: isSuccess,
      message: isSuccess ? body.toString() : '',
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
