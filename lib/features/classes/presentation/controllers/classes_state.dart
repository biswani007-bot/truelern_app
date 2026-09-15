import '../../domain/entities/class_entity.dart';

/// Sealed state hierarchy for the classes schedule controller.
sealed class ClassesState {
  const ClassesState();
}

/// Initial state — schedule not yet requested.
final class ClassesInitial extends ClassesState {
  const ClassesInitial();
}

/// Fetching live class schedule for the active child.
final class ClassesLoading extends ClassesState {
  const ClassesLoading();
}

/// Classes successfully loaded.
/// [classes] may be empty if no sessions are scheduled.
final class ClassesLoaded extends ClassesState {
  const ClassesLoaded({required this.classes});

  final List<ClassEntity> classes;

  /// True if there is at least one scheduled class.
  bool get hasClasses => classes.isNotEmpty;
}

/// Classes API call failed.
final class ClassesError extends ClassesState {
  const ClassesError({required this.message});

  final String message;
}

/// No active child context — cannot query live classes.
final class ClassesNoChild extends ClassesState {
  const ClassesNoChild();
}
