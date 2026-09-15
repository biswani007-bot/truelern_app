import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/assignments_repository.dart';
import '../../data/repositories/assignments_repository_impl.dart';
import '../../domain/entities/assignment_entity.dart';
import 'assignments_state.dart';

class AssignmentsController extends Notifier<AssignmentsState> {
  @override
  AssignmentsState build() {
    return const AssignmentsLoaded(
      allAssignments: [
        AssignmentEntity(
          id: 'asg_1',
          title: "The Grandmaster's Homework",
          topic: 'Practical Thinking',
          status: AssignmentStatus.pending,
          dueDate: 'Due: Feb 20',
          buttonText: 'Open Assignment',
        ),
        AssignmentEntity(
          id: 'asg_2',
          title: 'Confidence Quiz',
          topic: 'Communication',
          status: AssignmentStatus.completed,
          score: 95,
          totalMarks: 100,
        ),
        AssignmentEntity(
          id: 'asg_3',
          title: 'Daily Habits Tracker',
          topic: 'Time Management',
          status: AssignmentStatus.overdue,
          overdueDate: 'Was due: Feb 10',
          buttonText: 'Submit Late',
          isLateSubmissionAllowed: true,
        ),
      ],
      selectedFilter: 'All',
    );
  }

  AssignmentsRepository get _repository => ref.read(assignmentsRepositoryProvider);

  Future<void> loadAssignments({String? childStudentId}) async {
    try {
      final items = await _repository.getAssignments(
        childStudentId: childStudentId ?? 'default_child',
      );
      state = AssignmentsLoaded(allAssignments: items, selectedFilter: 'All');
    } catch (e) {
      // Keep existing loaded state or set error
    }
  }

  void setFilter(String filter) {
    if (state is AssignmentsLoaded) {
      final loaded = state as AssignmentsLoaded;
      state = loaded.copyWith(selectedFilter: filter);
    }
  }
}

/// Provider for [AssignmentsController].
final assignmentsControllerProvider =
    NotifierProvider<AssignmentsController, AssignmentsState>(() {
  return AssignmentsController();
});
