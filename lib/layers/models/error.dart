class AppError {
  final String message;
  final StackTrace trace;

  const AppError(this.message, this.trace);
}
