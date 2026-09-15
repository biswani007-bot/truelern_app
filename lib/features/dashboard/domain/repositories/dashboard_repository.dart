import '../entities/child_entity.dart';
import '../entities/dashboard_entity.dart';

/// Abstract repository contract for Dashboard domain operations.
///
/// Governance: All methods map strictly to verified Postman endpoints.
/// docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md — Folder 04
abstract class DashboardRepository {
  /// Fetches the list of children linked to the authenticated parent.
  ///
  /// Endpoint: GET /api/parent/children
  /// Auth: Bearer token (injected by AuthInterceptor)
  /// Returns: List of [ChildEntity]. Empty list if no children linked.
  /// Throws: [Failure] subtypes on network/server errors.
  Future<List<ChildEntity>> getLinkedChildren();

  /// Fetches dashboard summary metrics for the given [childStudentId].
  ///
  /// Endpoint: GET /api/parent/children/{childStudentId}/dashboard
  /// Auth: Bearer token (injected by AuthInterceptor)
  /// Throws: [Failure] subtypes on network/server errors.
  Future<DashboardEntity> getChildDashboard({required String childStudentId});
}
