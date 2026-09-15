import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/assignments/domain/entities/assignment_entity.dart';
import 'package:truelearn/features/assignments/presentation/screens/assignment_submitted_screen.dart';

void main() {
  group('AssignmentSubmittedScreen Widget Tests (Figma Node 76:2611)', () {
    testWidgets('renders hero section, submission details card, related class card, and back button', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const assignment = AssignmentEntity(
        id: 'asg_2',
        title: 'Confidence Quiz',
        topic: 'Practical Thinking',
        status: AssignmentStatus.completed,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: AssignmentSubmittedScreen(
            assignmentId: 'asg_2',
            assignment: assignment,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // 1. Hero Section
      expect(find.text('Assignment Submitted'), findsOneWidget);
      expect(find.textContaining('Great job! Your Practical Thinking assignment is'), findsOneWidget);
      expect(find.textContaining('securely in the hands of our reviewers.'), findsOneWidget);

      // 2. Submission Details Card
      expect(find.text('Submission Details'), findsOneWidget);
      expect(find.text('Submitted'), findsOneWidget);
      expect(find.text('Today, 4:30 PM'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('Under Review'), findsOneWidget);

      // 3. Related Class Context Card
      expect(find.text('PRACTICAL THINKING'), findsOneWidget);
      expect(find.text('Problem Solving 101'), findsOneWidget);
      expect(find.textContaining('This assignment is connected to the recent live class.'), findsOneWidget);
      expect(find.text('View Class Details'), findsOneWidget);
      expect(find.byKey(const Key('view_class_details_link')), findsOneWidget);

      // 4. Primary CTA: BACK TO LEARNING
      expect(find.text('BACK TO LEARNING'), findsOneWidget);
      expect(find.byKey(const Key('back_to_learning_button')), findsOneWidget);
    });
  });
}
