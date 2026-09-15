import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truelearn/features/dashboard/presentation/screens/parent_learning_progress_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildTestWidget() {
    return const MaterialApp(
      home: ParentLearningProgressScreen(),
    );
  }

  group('ParentLearningProgressScreen (Figma Node 76:3053)', () {
    testWidgets('renders all static UI elements accurately', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Top App Bar
      expect(find.byKey(const Key('learning_progress_drawer_button')), findsOneWidget);
      expect(find.byKey(const Key('learning_progress_bell_button')), findsOneWidget);

      // Header & Pill
      expect(find.text('My Progress'), findsOneWidget);
      expect(find.text('Public Speaking & Communication'), findsOneWidget);

      // Overall Progress Dial Card
      expect(find.text('72%'), findsOneWidget);
      expect(find.text('Overall Mastery'), findsOneWidget);

      // 4 Skill Cards
      expect(find.byKey(const Key('skill_card_public_speaking')), findsOneWidget);
      expect(find.text('Public Speaking'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);

      expect(find.byKey(const Key('skill_card_communication')), findsOneWidget);
      expect(find.text('Communication'), findsOneWidget);
      expect(find.text('71%'), findsOneWidget);

      expect(find.byKey(const Key('skill_card_emotional_intelligence')), findsOneWidget);
      expect(find.text('Emotional Intelligence'), findsOneWidget);
      expect(find.text('64%'), findsOneWidget);

      expect(find.byKey(const Key('skill_card_practical_thinking')), findsOneWidget);
      expect(find.text('Practical Thinking'), findsOneWidget);
      expect(find.text('58%'), findsOneWidget);

      // View Detailed Report Button
      expect(find.byKey(const Key('view_detailed_report_button')), findsOneWidget);
      expect(find.text('View Detailed Report'), findsOneWidget);

      // Single Bottom Navigation Bar
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('My Classes'), findsOneWidget);
      expect(find.text('Assignment'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });
  });
}
