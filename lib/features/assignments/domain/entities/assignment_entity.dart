/// Status enum for assignments.
enum AssignmentStatus {
  pending,
  completed,
  overdue,
}

/// Domain entity representing an assignment in TrueLern.
class AssignmentEntity {
  final String id;
  final String title;
  final String topic; // e.g. "Practical Thinking", "Communication", "Time Management"
  final AssignmentStatus status;
  final String? dueDate; // e.g. "Due: Feb 20"
  final String? overdueDate; // e.g. "Was due: Feb 10"
  final int? score; // e.g. 95
  final int? totalMarks; // e.g. 100
  final String? buttonText; // e.g. "Open Assignment", "Submit Late"
  final bool isLateSubmissionAllowed;

  const AssignmentEntity({
    required this.id,
    required this.title,
    required this.topic,
    required this.status,
    this.dueDate,
    this.overdueDate,
    this.score,
    this.totalMarks,
    this.buttonText,
    this.isLateSubmissionAllowed = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssignmentEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          topic == other.topic &&
          status == other.status &&
          dueDate == other.dueDate &&
          overdueDate == other.overdueDate &&
          score == other.score &&
          totalMarks == other.totalMarks &&
          buttonText == other.buttonText &&
          isLateSubmissionAllowed == other.isLateSubmissionAllowed;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      topic.hashCode ^
      status.hashCode ^
      dueDate.hashCode ^
      overdueDate.hashCode ^
      score.hashCode ^
      totalMarks.hashCode ^
      buttonText.hashCode ^
      isLateSubmissionAllowed.hashCode;
}
