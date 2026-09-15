import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/child_dto.dart';
import '../models/dashboard_dto.dart';

/// Concrete implementation of [DashboardRepository].
///
/// Uses the existing [ApiClient] which automatically attaches
/// `Authorization: Bearer <accessToken>` via the AuthInterceptor.
/// No manual token passing is done here.
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  /// GET /api/parent/children
  ///
  /// Returns the list of children linked to the authenticated parent.
  /// Returns an empty list if the data array is empty.
  /// All JSON field access is null-safe.
  @override
  Future<List<ChildEntity>> getLinkedChildren() async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/parent/children',
    );

    final body = response.data;
    if (body == null) return [];

    // Unwrap standard envelope: { "success": true, "data": [...] }
    final dataField = body['data'];
    if (dataField == null) return [];

    // data may be a List directly or wrapped further
    final List<dynamic> rawList;
    if (dataField is List) {
      rawList = dataField;
    } else if (dataField is Map<String, dynamic> && dataField['children'] is List) {
      rawList = dataField['children'] as List<dynamic>;
    } else {
      return [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .map((json) => ChildDto.fromJson(json).toEntity())
        .toList();
  }

  /// GET /api/parent/children/{childStudentId}/dashboard
  ///
  /// Returns dashboard summary metrics for the given child.
  @override
  Future<DashboardEntity> getChildDashboard({
    required String childStudentId,
  }) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/parent/children/$childStudentId/dashboard',
    );

    final body = response.data;
    if (body == null) return const DashboardEntity();

    final dataField = body['data'];
    if (dataField is! Map<String, dynamic>) return const DashboardEntity();

    return DashboardDto.fromJson(dataField).toEntity();
  }
}

/// Provider for [DashboardRepository].
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(apiClient: ref.watch(apiClientProvider));
});
