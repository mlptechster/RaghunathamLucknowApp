// lib/utlis/exceptions/server_exception.dart

class ServerException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const ServerException(
    this.message, {
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'ServerException(code: $code, message: $message)';
}
