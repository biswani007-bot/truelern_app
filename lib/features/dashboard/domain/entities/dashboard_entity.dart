/// Domain entity for Parent Dashboard summary metrics.
///
/// Source: GET /api/parent/children/{childStudentId}/dashboard
/// Governance: docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md — Folder 04, Item 2
class DashboardEntity {
  const DashboardEntity({
    this.attendanceRate,
    this.upcomingClassesCount,
    this.pendingAssignmentsCount,
    this.totalBalanceDue,
  });

  /// Attendance percentage for the active child (0.0–100.0). Null if not available.
  final double? attendanceRate;

  /// Count of scheduled upcoming live classes. Null if not available.
  final int? upcomingClassesCount;

  /// Count of assignments pending submission. Null if not available.
  final int? pendingAssignmentsCount;

  /// Outstanding tuition balance due. Null if not available.
  final double? totalBalanceDue;

  /// Returns true if the entity has at least one non-null metric.
  bool get hasData =>
      attendanceRate != null ||
      upcomingClassesCount != null ||
      pendingAssignmentsCount != null ||
      totalBalanceDue != null;
}
