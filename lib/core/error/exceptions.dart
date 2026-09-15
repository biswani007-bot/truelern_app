/// Base application exception.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message (code: $statusCode)';
}

/// Thrown when a low-level network failure occurs (e.g. SocketException).
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

/// Thrown when a request exceeds configured timeouts.
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Network request timed out.']);
}

/// Thrown when backend returns an HTTP error status code.
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode, this.responseBody});

  final dynamic responseBody;
}

/// Thrown on HTTP 401 or 403 authorization failures.
class AuthException extends AppException {
  const AuthException([
    super.message = 'Authentication failed.',
    int? statusCode = 401,
  ]) : super(statusCode: statusCode);
}

/// Thrown when storage operations fail.
class StorageException extends AppException {
  const StorageException(super.message);
}
