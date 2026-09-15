import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/dashboard/presentation/screens/teacher_feedback_screen.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/parent_hamburger_drawer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createSubject() {
    return const MaterialApp(
      home: TeacherFeedbackScreen(),
    );
  }

  testWidgets('TeacherFeedbackScreen renders all Figma Node 76:2697 components accurately', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // 1. Top App Bar
    expect(find.byKey(const Key('teacher_feedback_screen')), findsOneWidget);
    expect(find.byKey(const Key('teacher_feedback_back_button')), findsOneWidget);
    expect(find.byKey(const Key('teacher_feedback_notifications_button')), findsOneWidget);

    // 2. Assignment Header
    expect(find.text('DESIGN THINKING PROJECT'), findsOneWidget);
    expect(find.text('REVIEWED'), findsOneWidget);
    expect(find.text('Build a Sustainable City Model'), findsOneWidget);
    expect(find.text('Submitted on Oct 24, 2023'), findsOneWidget);

    // 3. Feedback Card (Ms. Sarah + 95/100 + Quote)
    expect(find.text('Feedback from Ms. Sarah'), findsOneWidget);
    expect(find.text('Lead Instructor, Practical Thinking'), findsOneWidget);
    expect(find.text('95'), findsOneWidget);
    expect(find.text('/100'), findsOneWidget);
    expect(find.text('Excellent\nScore!'), findsOneWidget);
    expect(
      find.textContaining('Exceptional work on the sustainable city model!'),
      findsOneWidget,
    );

    // 4. Skill Impact Section
    expect(find.text('Skill Impact'), findsOneWidget);
    expect(find.text('Practical Thinking'), findsOneWidget);
    expect(find.text('+12%'), findsOneWidget);
    expect(find.text('Problem Solving'), findsOneWidget);
    expect(find.text('+8%'), findsOneWidget);

    // 5. CTA Button
    expect(find.byKey(const Key('teacher_feedback_continue_button')), findsOneWidget);
    expect(find.text('CONTINUE LEARNING'), findsOneWidget);

    // 6. Bottom Navigation Bar (Figma Node 76:2698)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My Classes'), findsOneWidget);
    expect(find.text('Assignment'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('ParentHamburgerDrawer displays Teacher Updates option', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          drawer: ParentHamburgerDrawer(),
        ),
      ),
    );

    // Open drawer
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Teacher Updates'), findsOneWidget);
  });
}
