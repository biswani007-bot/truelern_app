import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'children_controller.dart';
import 'children_state.dart';
import 'dashboard_state.dart';

/// Manages the dashboard data for the currently active child.
///
/// Governance:
/// - Calls GET /api/parent/children/{childStudentId}/dashboard
/// - Requires a valid childStudentId from ChildrenController
/// - If no child context: transitions to DashboardNoChild (not an error)
/// - All data values come from the real API response
class DashboardController extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardInitial();

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  /// Loads dashboard data for the given [childStudentId].
  ///
  /// Caller must provide the activeChildId from ChildrenController.
  /// If null, transitions to [DashboardNoChild].
  Future<void> loadDashboard({required String? childStudentId}) async {
    if (childStudentId == null || childStudentId.isEmpty) {
      state = const DashboardNoChild();
      return;
    }

    state = const DashboardLoading();
    try {
      final entity = await _repository.getChildDashboard(
        childStudentId: childStudentId,
      );
      state = DashboardLoaded(dashboard: entity);
    } catch (error) {
      state = DashboardError(message: _messageFrom(error));
    }
  }

  /// Retries the dashboard fetch using the current active child from ChildrenController.
  Future<void> retry() async {
    final childrenState = ref.read(childrenControllerProvider);
    final childId = childrenState is ChildrenLoaded
        ? childrenState.activeChildId
        : null;
    await loadDashboard(childStudentId: childId);
  }

  String _messageFrom(Object error) {
    final s = error.toString();
    // Extract user-friendly message from Failure.toString()
    final match = RegExp(r'message: (.+?)(,|$)').firstMatch(s);
    return match?.group(1) ?? 'Unable to load dashboard. Please try again.';
  }
}

/// Global provider for [DashboardController].
final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(DashboardController.new);
