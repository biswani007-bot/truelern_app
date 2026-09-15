import '../../domain/entities/dashboard_entity.dart';

/// Data Transfer Object for dashboard summary metrics.
///
/// Governance: docs/project-source-of-truth/03-API-SOURCE-OF-TRUTH.md — Folder 04, Item 2
/// Endpoint: GET /api/parent/children/{childStudentId}/dashboard
/// Response envelope: { "success": true, "data": { attendanceRate, upcomingClassesCount, ... } }
class DashboardDto {
  const DashboardDto({
    this.attendanceRate,
    this.upcomingClassesCount,
    this.pendingAssignmentsCount,
    this.totalBalanceDue,
  });

  final double? attendanceRate;
  final int? upcomingClassesCount;
  final int? pendingAssignmentsCount;
  final double? totalBalanceDue;

  /// Parses dashboard metrics from the `data` payload of the API response.
  ///
  /// All fields are treated as optional — the server may return partial data.
  /// No defaults are invented; null means "not available from API".
  factory DashboardDto.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return DashboardDto(
      attendanceRate: parseDouble(json['attendanceRate']),
      upcomingClassesCount: parseInt(json['upcomingClassesCount']),
      pendingAssignmentsCount: parseInt(json['pendingAssignmentsCount']),
      totalBalanceDue: parseDouble(json['totalBalanceDue']),
    );
  }

  /// Converts DTO to domain entity.
  DashboardEntity toEntity() => DashboardEntity(
        attendanceRate: attendanceRate,
        upcomingClassesCount: upcomingClassesCount,
        pendingAssignmentsCount: pendingAssignmentsCount,
        totalBalanceDue: totalBalanceDue,
      );
}
