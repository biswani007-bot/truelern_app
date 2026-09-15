import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/controllers/children_controller.dart';
import '../../../dashboard/presentation/controllers/children_state.dart';
import '../../data/repositories/classes_repository_impl.dart';
import '../../domain/repositories/classes_repository.dart';
import 'classes_state.dart';

/// Manages live class schedule data for the currently active child.
///
/// Governance:
/// - Authoritative API: GET /api/parent/children/{childStudentId}/live-classes
/// - Requires valid childStudentId derived from ChildrenController
/// - Reactive to child changes without stale data leakage
/// - Handles empty array (HTTP 200 + []) cleanly via ClassesLoaded(classes: [])
class ClassesController extends Notifier<ClassesState> {
  @override
  ClassesState build() => const ClassesInitial();

  ClassesRepository get _repository => ref.read(classesRepositoryProvider);

  /// Loads live class schedule for the given [childStudentId].
  ///
  /// If [childStudentId] is null or empty, transitions to [ClassesNoChild].
  Future<void> loadClasses({required String? childStudentId}) async {
    if (childStudentId == null || childStudentId.isEmpty) {
      state = const ClassesNoChild();
      return;
    }

    state = const ClassesLoading();
    try {
      final list = await _repository.getLiveClasses(childStudentId);
      state = ClassesLoaded(classes: list);
    } catch (error) {
      state = ClassesError(message: _messageFrom(error));
    }
  }

  /// Retries the fetch using the active child from [ChildrenController].
  Future<void> retry() async {
    final childrenState = ref.read(childrenControllerProvider);
    final childId = childrenState is ChildrenLoaded
        ? childrenState.activeChildId
        : null;
    await loadClasses(childStudentId: childId);
  }

  String _messageFrom(Object error) {
    final s = error.toString();
    final match = RegExp(r'message: (.+?)(,|$)').firstMatch(s);
    return match?.group(1) ?? 'Unable to load classes schedule. Please try again.';
  }
}

/// Global provider for [ClassesController].
final classesControllerProvider =
    NotifierProvider<ClassesController, ClassesState>(ClassesController.new);
