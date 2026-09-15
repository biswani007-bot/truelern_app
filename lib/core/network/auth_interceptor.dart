import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';

/// Interceptor that attaches a Bearer JWT to outgoing requests if available.
///
/// Strictly abides by TrueLern security invariants:
/// - NEVER generates fake JWTs.
/// - NEVER bypasses authentication.
/// - If no token exists in secure storage, request proceeds unauthenticated.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.storageService});

  final SecureStorageService storageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix}$token';
      }
    } catch (_) {
      // If secure storage access fails, proceed without token rather than crashing
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Generic reusable 401 handling (e.g. signal session expiration if needed)
    }
    return handler.next(err);
  }
}
