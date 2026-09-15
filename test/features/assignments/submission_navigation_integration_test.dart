import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:truelearn/features/assignments/domain/entities/assignment_entity.dart';
import 'package:truelearn/features/assignments/presentation/screens/assignment_submission_screen.dart';
import 'package:truelearn/features/assignments/presentation/screens/assignment_submitted_screen.dart';

void main() {
  group('Submission to Submitted Navigation Integration Test', () {
    testWidgets('tapping Submit Now animates upload and navigates to AssignmentSubmittedScreen', (tester) async {
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
        initialLocation: '/parent/assignments/test-101/submission',
        routes: [
          GoRoute(
            path: '/parent/assignments/:assignmentId/submission',
            builder: (context, state) => AssignmentSubmissionScreen(
              assignmentId: state.pathParameters['assignmentId'],
              assignment: testAssignment,
              showAllStatesOverview: false,
            ),
          ),
          GoRoute(
            path: '/parent/assignments/:assignmentId/submitted',
            builder: (context, state) => AssignmentSubmittedScreen(
              assignmentId: state.pathParameters['assignmentId'],
              assignment: testAssignment,
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Verify on Submission Screen
      expect(find.text('Assignment'), findsOneWidget);
      expect(find.text('Tap to upload file'), findsOneWidget);

      // 1. Upload draft
      await tester.tap(find.byKey(const Key('tap_to_upload_box')));
      await tester.pumpAndSettle();
      expect(find.text('Draft Saved'), findsOneWidget);
      expect(find.byKey(const Key('submit_now_button')), findsOneWidget);

      // 2. Tap Submit Now
      await tester.tap(find.byKey(const Key('submit_now_button')));
      await tester.pump();
      expect(find.text('Submitting...'), findsOneWidget);
      expect(find.text('Uploading file...'), findsOneWidget);

      // 3. Advance timer to complete upload
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // 4. Verify we arrived on AssignmentSubmittedScreen
      expect(find.text('Assignment Submitted'), findsOneWidget);
      expect(find.textContaining('Great job! Your Practical Thinking assignment is'), findsOneWidget);
      expect(find.text('Submission Details'), findsOneWidget);
      expect(find.text('Under Review'), findsOneWidget);
      expect(find.text('BACK TO LEARNING'), findsOneWidget);
    });

    testWidgets('tapping State 4 Submitted card navigates directly to AssignmentSubmittedScreen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const testAssignment = AssignmentEntity(
        id: 'test-102',
        title: 'Design a Rube Goldberg Machine',
        topic: 'Practical Thinking',
        status: AssignmentStatus.pending,
        dueDate: 'Due: Friday, 11:59 PM',
      );

      final router = GoRouter(
        initialLocation: '/parent/assignments/test-102/submission',
        routes: [
          GoRoute(
            path: '/parent/assignments/:assignmentId/submission',
            builder: (context, state) => AssignmentSubmissionScreen(
              assignmentId: state.pathParameters['assignmentId'],
              assignment: testAssignment,
              showAllStatesOverview: true,
            ),
          ),
          GoRoute(
            path: '/parent/assignments/:assignmentId/submitted',
            builder: (context, state) => AssignmentSubmittedScreen(
              assignmentId: state.pathParameters['assignmentId'],
              assignment: testAssignment,
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Verify overview mode renders State 4 card
      expect(find.byKey(const Key('submitted_card_link')), findsOneWidget);

      // Tap State 4 card
      await tester.ensureVisible(find.byKey(const Key('submitted_card_link')));
      await tester.tap(find.byKey(const Key('submitted_card_link')));
      await tester.pumpAndSettle();

      // Arrives on AssignmentSubmittedScreen
      expect(find.text('Assignment Submitted'), findsOneWidget);
      expect(find.text('BACK TO LEARNING'), findsOneWidget);
    });
  });
}
