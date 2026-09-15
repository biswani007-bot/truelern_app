import '../../domain/entities/assignment_entity.dart';

/// Data Transfer Object for assignment representations.
class AssignmentDto {
  final String id;
  final String title;
  final String? topic;
  final String status;
  final String? dueDate;
  final String? overdueDate;
  final int? score;
  final int? totalMarks;
  final String? buttonText;
  final bool? isLateSubmissionAllowed;

  const AssignmentDto({
    required this.id,
    required this.title,
    this.topic,
    required this.status,
    this.dueDate,
    this.overdueDate,
    this.score,
    this.totalMarks,
    this.buttonText,
    this.isLateSubmissionAllowed,
  });

  factory AssignmentDto.fromJson(Map<String, dynamic> json) {
    return AssignmentDto(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Assignment',
      topic: json['topic']?.toString() ?? json['subject']?.toString() ?? 'Academics',
      status: json['status']?.toString().toLowerCase() ?? 'pending',
      dueDate: json['dueDate']?.toString() ?? json['due']?.toString(),
      overdueDate: json['overdueDate']?.toString() ?? json['wasDue']?.toString(),
      score: (json['score'] as num?)?.toInt() ?? (json['marks'] as num?)?.toInt(),
      totalMarks: (json['totalMarks'] as num?)?.toInt() ?? (json['maxMarks'] as num?)?.toInt() ?? 100,
      buttonText: json['buttonText']?.toString(),
      isLateSubmissionAllowed: json['isLateSubmissionAllowed'] as bool? ?? false,
    );
  }

  AssignmentEntity toEntity() {
    final parsedStatus = switch (status) {
      'completed' || 'submitted' || 'evaluated' => AssignmentStatus.completed,
      'overdue' || 'late' || 'missed' => AssignmentStatus.overdue,
      _ => AssignmentStatus.pending,
    };

    return AssignmentEntity(
      id: id,
      title: title,
      topic: topic ?? 'General',
      status: parsedStatus,
      dueDate: dueDate,
      overdueDate: overdueDate,
      score: score,
      totalMarks: totalMarks,
      buttonText: buttonText ?? (parsedStatus == AssignmentStatus.overdue ? 'Submit Late' : 'Open Assignment'),
      isLateSubmissionAllowed: isLateSubmissionAllowed ?? false,
    );
  }
}
