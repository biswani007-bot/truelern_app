import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/classes_repository.dart';
import '../models/class_dto.dart';

/// Concrete implementation of [ClassesRepository].
///
/// Uses the existing [ApiClient] which automatically attaches
/// `Authorization: Bearer <accessToken>` via the [AuthInterceptor].
///
/// Governance:
/// - Authoritative endpoint: GET /api/parent/children/{childStudentId}/live-classes
/// - Reuses existing ErrorHandler and Failure hierarchy.
/// - Defensive handling of empty list, empty envelope, and malformed structures.
class ClassesRepositoryImpl implements ClassesRepository {
  const ClassesRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<ClassEntity>> getLiveClasses(String childStudentId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/parent/children/$childStudentId/live-classes',
    );

    final body = response.data;
    if (body == null) return [];

    // Unwrap standard envelope: { "success": true, "data": [...], "meta": {...} }
    final dataField = body['data'];
    if (dataField == null) return [];

    final List<dynamic> rawList;
    if (dataField is List) {
      rawList = dataField;
    } else if (dataField is Map<String, dynamic> && dataField['classes'] is List) {
      rawList = dataField['classes'] as List<dynamic>;
    } else if (dataField is Map<String, dynamic> && dataField['items'] is List) {
      rawList = dataField['items'] as List<dynamic>;
    } else {
      return [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => ClassDto.fromJson(json).toEntity())
        .toList();
  }
}

/// Provider for [ClassesRepository].
final classesRepositoryProvider = Provider<ClassesRepository>((ref) {
  return ClassesRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});
