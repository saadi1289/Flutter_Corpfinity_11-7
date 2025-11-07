/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Exception thrown when network operations fail
class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'NETWORK_ERROR');
}

/// Exception thrown when authentication operations fail
class AuthException extends AppException {
  AuthException(String message) : super(message, 'AUTH_ERROR');
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  ValidationException(String message) : super(message, 'VALIDATION_ERROR');
}

/// Exception thrown for unexpected errors
class UnknownException extends AppException {
  UnknownException(String message) : super(message, 'UNKNOWN_ERROR');
}
