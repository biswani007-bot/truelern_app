import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:truelearn/features/assignments/domain/entities/assignment_entity.dart';
import 'package:truelearn/features/assignments/presentation/screens/assignment_submitted_screen.dart';
import 'package:truelearn/features/classes/presentation/screens/current_program_screen.dart';

void main() {
  testWidgets('tapping BACK TO LEARNING on AssignmentSubmittedScreen navigates to CurrentProgramScreen', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const testAssignment = AssignmentEntity(
      id: 'test-101',
      title: 'Design a Rube Goldberg Machine',
      topic: 'Practical Thinking',
      status: AssignmentStatus.pending,
      dueDate: 'Due: Friday, 11:59 PM',
    );

    final router = GoRouter(
      initialLocation: '/parent/assignments/test-101/submitted',
      routes: [
        GoRoute(
          path: '/parent/assignments/:assignmentId/submitted',
          builder: (context, state) => AssignmentSubmittedScreen(
            assignmentId: state.pathParameters['assignmentId'],
            assignment: testAssignment,
          ),
        ),
        GoRoute(
          path: '/parent/classes/program',
          builder: (context, state) => const CurrentProgramScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify on AssignmentSubmittedScreen
    expect(find.text('Assignment Submitted'), findsOneWidget);
    expect(find.byKey(const Key('back_to_learning_button')), findsOneWidget);

    // 2. Tap BACK TO LEARNING
    await tester.ensureVisible(find.byKey(const Key('back_to_learning_button')));
    await tester.tap(find.byKey(const Key('back_to_learning_button')));
    await tester.pumpAndSettle();

    // 3. Verify navigated to CurrentProgramScreen
    expect(find.text('ACTIVE TRACK'), findsOneWidget);
    expect(find.text('Communication & Public Speaking'), findsOneWidget);
    expect(find.text('Track Progress'), findsOneWidget);
    expect(find.text('Skills in Focus'), findsOneWidget);
  });
}
