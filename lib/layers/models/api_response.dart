class ApiResponse<T> {
  final int statusCode;
  final bool isSuccess;
  final String? message;
  final T data;

  static bool isSuccessStatusCode(int code) {
    return code > 199 && code < 300;
  }

  const ApiResponse({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.statusCode,
  });
}
