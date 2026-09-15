import '../../data/models/auth_response.dart';

/// Sealed hierarchy representing all UI authentication states.
sealed class AuthState {
  const AuthState();
}

/// Initial uninitialized state.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Active during app startup while checking local secure session.
final class AuthCheckingSession extends AuthState {
  const AuthCheckingSession();
}

/// Active while a login request is in-flight.
final class AuthSubmitting extends AuthState {
  const AuthSubmitting();
}

/// Active when genuine authentication has succeeded against the backend.
final class Authenticated extends AuthState {
  const Authenticated({
    required this.accessToken,
    this.user,
  });

  final String accessToken;
  final UserDto? user;
}

/// Active when unauthenticated and ready for user input on Login.
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// Active when a login request fails (HTTP 500, 401, timeout, or network drop).
final class AuthFailureState extends AuthState {
  const AuthFailureState({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;
}
