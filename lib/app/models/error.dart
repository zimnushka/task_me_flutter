class AppError {
  final String message;
  final StackTrace trace;

  const AppError(this.message, this.trace);
}

class LogicalException implements Exception {
  final String message;
  const LogicalException(this.message);
}
