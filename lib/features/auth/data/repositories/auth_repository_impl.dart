import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';

/// Concrete implementation of [AuthRepository] interacting with TrueLern production API.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.apiClient,
    required this.secureStorage,
  });

  final ApiClient apiClient;
  final SecureStorageService secureStorage;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    // Calls POST /api/auth/login using the single configured ApiClient
    final response = await apiClient.post<dynamic>(
      '/auth/login',
      data: request.toJson(),
    );

    if (response.data is! Map<String, dynamic>) {
      throw const ServerFailure('Invalid server response structure.');
    }

    final authResponse = AuthResponse.fromJson(response.data as Map<String, dynamic>);

    if (authResponse.accessToken.isEmpty) {
      throw const ServerFailure('Authentication token was not returned by the server.');
    }

    // Persist session tokens only after genuine server validation
    await secureStorage.saveAccessToken(authResponse.accessToken);
    if (authResponse.refreshToken != null && authResponse.refreshToken!.isNotEmpty) {
      await secureStorage.saveRefreshToken(authResponse.refreshToken!);
    }
    if (authResponse.user != null) {
      await secureStorage.saveUserId(authResponse.user!.id);
    }

    return authResponse;
  }

  @override
  Future<String?> checkPersistedSession() async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {
      // Storage read failure defaults to unauthenticated
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await secureStorage.clearAuthSession();
  }
}

/// Global provider for [AuthRepository].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiClient: ref.watch(apiClientProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});
