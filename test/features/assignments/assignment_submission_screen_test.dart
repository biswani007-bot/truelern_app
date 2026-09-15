import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/assignments/domain/entities/assignment_entity.dart';
import 'package:truelearn/features/assignments/presentation/screens/assignment_submission_screen.dart';

void main() {
  group('AssignmentSubmissionScreen Widget Tests', () {
    testWidgets('renders all 4 states in overview mode and responds to taps', (tester) async {
      const assignment = AssignmentEntity(
        id: 'asg-1',
        title: 'Design a Rube\nGoldberg Machine',
        topic: 'Practical Thinking',
        status: AssignmentStatus.pending,
        dueDate: 'Due: Friday, 11:59 PM',
      );

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AssignmentSubmissionScreen(
            assignment: assignment,
            showAllStatesOverview: true,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Top Header
      expect(find.text('Assignment'), findsOneWidget);
      expect(find.byKey(const Key('submission_back_button')), findsOneWidget);

      // Header Section
      expect(find.text('Practical Thinking'), findsOneWidget);
      expect(find.text('Design a Rube\nGoldberg Machine'), findsOneWidget);
      expect(find.text('Due: Friday, 11:59 PM'), findsOneWidget);

      // State 1: Not Started
      expect(find.text('Not Started'), findsOneWidget);
      expect(find.text('Tap to upload file'), findsOneWidget);
      expect(find.byKey(const Key('tap_to_upload_box')), findsOneWidget);

      // State 2: Draft Saved
      expect(find.text('Draft Saved'), findsOneWidget);
      expect(find.text('my_rube_goldberg_plan.pdf'), findsOneWidget);
      expect(find.text('Replace'), findsOneWidget);
      expect(find.text('Submit Now'), findsOneWidget);

      // State 3: Submitting
      expect(find.text('Submitting...'), findsOneWidget);
      expect(find.text('Uploading file...'), findsOneWidget);

      // State 4: Submitted
      expect(find.text('Submission Status'), findsOneWidget);
      expect(find.text('Submitted'), findsOneWidget);
      expect(find.text('Great job!'), findsOneWidget);
      expect(find.text('final_project_v2.pdf'), findsOneWidget);
      expect(find.text('View'), findsOneWidget);

      // Test interaction with Replace button
      await tester.ensureVisible(find.byKey(const Key('replace_file_button')));
      await tester.tap(find.byKey(const Key('replace_file_button')));
      await tester.pump();
      expect(find.text('updated_goldberg_plan_v2.pdf'), findsOneWidget);

      // Test interaction with View button
      await tester.ensureVisible(find.byKey(const Key('view_submitted_file_button')));
      await tester.tap(find.byKey(const Key('view_submitted_file_button')));
      await tester.pump();
    });

    testWidgets('interactive mode: starts in Not Started, uploads file to Draft Saved, and deletes file back to Not Started', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AssignmentSubmissionScreen(
            assignmentId: 'asg-test',
            showAllStatesOverview: false,
          ),
        ),
      );
      await tester.pump();

      // Initially in Not Started state
      expect(find.text('Not Started'), findsOneWidget);
      expect(find.text('Tap to upload file'), findsOneWidget);
      expect(find.byKey(const Key('tap_to_upload_box')), findsOneWidget);
      expect(find.byKey(const Key('submit_now_button')), findsNothing);

      // Tap upload box to transition to Draft Saved
      await tester.tap(find.byKey(const Key('tap_to_upload_box')));
      await tester.pump();

      expect(find.text('Draft Saved'), findsOneWidget);
      expect(find.text('my_rube_goldberg_plan.pdf'), findsOneWidget);
      expect(find.byKey(const Key('submit_now_button')), findsOneWidget);
      expect(find.byKey(const Key('delete_draft_file_button')), findsOneWidget);

      // Delete draft file to return to Not Started
      await tester.tap(find.byKey(const Key('delete_draft_file_button')));
      await tester.pump();

      expect(find.text('Not Started'), findsOneWidget);
      expect(find.text('Tap to upload file'), findsOneWidget);
      expect(find.byKey(const Key('submit_now_button')), findsNothing);
    });

    testWidgets('interactive mode: Submit Now animates through progress and completes navigation flow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AssignmentSubmissionScreen(
            assignmentId: 'asg-test',
            showAllStatesOverview: false,
          ),
        ),
      );
      await tester.pump();

      // Move to Draft Saved
      await tester.tap(find.byKey(const Key('tap_to_upload_box')));
      await tester.pump();
      expect(find.byKey(const Key('submit_now_button')), findsOneWidget);

      // Tap Submit Now -> transitions to Submitting
      await tester.tap(find.byKey(const Key('submit_now_button')));
      await tester.pump();

      expect(find.text('Submitting...'), findsOneWidget);
      expect(find.text('Uploading file...'), findsOneWidget);

      // Advance periodic timer through 25% increments to 100%
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // State is now submitted
      expect(find.text('Submission Status'), findsOneWidget);
      expect(find.text('Submitted'), findsOneWidget);
      expect(find.text('Great job!'), findsOneWidget);
    });
  });
}
