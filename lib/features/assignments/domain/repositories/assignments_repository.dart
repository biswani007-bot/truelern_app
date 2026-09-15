import '../entities/assignment_entity.dart';

/// Contract for fetching child assignments.
abstract class AssignmentsRepository {
  Future<List<AssignmentEntity>> getAssignments({required String childStudentId});
}
