import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'children_state.dart';

/// Manages the list of linked children and the active child context.
///
/// Governance:
/// - Calls GET /api/parent/children via DashboardRepository
/// - Sets activeChildId to first child by default
/// - If no children: transitions to ChildrenLoaded with empty list
/// - No hardcoded children, no invented child IDs
class ChildrenController extends Notifier<ChildrenState> {
  @override
  ChildrenState build() => const ChildrenInitial();

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  /// Fetches linked children. Sets first child as active by default.
  Future<void> loadChildren() async {
    state = const ChildrenLoading();
    try {
      final children = await _repository.getLinkedChildren();
      state = ChildrenLoaded(
        children: children,
        activeChildId: children.isNotEmpty ? children.first.studentId : null,
      );
    } catch (error) {
      state = ChildrenError(message: _messageFrom(error));
    }
  }

  /// Retries the children fetch after a failure.
  Future<void> retry() => loadChildren();

  /// Switches the active child context and triggers dashboard reload.
  void setActiveChild(String studentId) {
    final current = state;
    if (current is ChildrenLoaded) {
      final exists = current.children.any((c) => c.studentId == studentId);
      if (!exists) return;
      state = ChildrenLoaded(
        children: current.children,
        activeChildId: studentId,
      );
    }
  }

  String _messageFrom(Object error) {
    // Failure types are already user-friendly messages from ErrorHandler
    return error.toString().replaceFirst(RegExp(r'^.*\(message: '), '').replaceFirst(RegExp(r',.*$'), '');
  }
}

/// Global provider for [ChildrenController].
final childrenControllerProvider =
    NotifierProvider<ChildrenController, ChildrenState>(ChildrenController.new);
