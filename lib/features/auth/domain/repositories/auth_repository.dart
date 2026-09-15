import '../../data/models/auth_response.dart';
import '../../data/models/login_request.dart';

/// Contract for authentication operations.
abstract interface class AuthRepository {
  /// Submits credentials to POST /api/auth/login.
  /// Throws [Failure] on error.
  Future<AuthResponse> login(LoginRequest request);

  /// Checks if a persisted access token exists in secure storage.
  Future<String?> checkPersistedSession();

  /// Clears secure storage and terminates active session.
  Future<void> logout();
}
