import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/classes/domain/entities/class_entity.dart';
import 'package:truelearn/features/classes/presentation/screens/class_summary_screen.dart';

void main() {
  testWidgets('ClassSummaryScreen renders header, hero elements, practiced skills, and CTA button', (tester) async {
    final mockSession = ClassEntity(
      id: 'session-101',
      title: 'Public Speaking Fundamentals',
      subject: 'Communication',
      teacherName: 'Sarah Jenkins',
      scheduledStartTime: DateTime.now(),
      status: 'COMPLETED',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ClassSummaryScreen(
            classId: 'session-101',
            session: mockSession,
          ),
        ),
      ),
    );

    // Verify Header
    expect(find.byKey(const Key('summary_menu_button')), findsOneWidget);
    expect(find.byKey(const Key('summary_notifications_button')), findsOneWidget);

    // Verify Hero elements
    expect(find.text('Class Completed'), findsOneWidget);
    expect(find.text('Attended'), findsOneWidget);
    expect(find.text('42 / 45 minutes'), findsOneWidget);
    expect(find.text('Teacher: Sarah'), findsOneWidget);

    // Verify "WHAT WE PRACTICED" section
    expect(find.text('WHAT WE PRACTICED'), findsOneWidget);
    expect(find.text('Voice'), findsOneWidget);
    expect(find.text('Communication'), findsOneWidget);
    expect(find.text('Confidence'), findsOneWidget);

    // Verify "NEXT STEPS" section
    expect(find.text('NEXT STEPS'), findsOneWidget);
    expect(find.text('Next Live Class'), findsOneWidget);
    expect(find.text('Tomorrow, 7 PM'), findsOneWidget);
    expect(find.text('Assignment'), findsOneWidget);
    expect(find.text('Due Friday'), findsOneWidget);

    // Verify CTA button
    expect(find.byKey(const Key('view_assignment_button')), findsOneWidget);
    expect(find.text('VIEW ASSIGNMENT'), findsOneWidget);
  });
}
