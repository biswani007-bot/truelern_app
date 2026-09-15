import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/classes/presentation/screens/current_program_screen.dart';

void main() {
  testWidgets('CurrentProgramScreen renders all Figma Node 76:2787 elements', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CurrentProgramScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Top App Bar (Node 76:2899)
    expect(find.byKey(const Key('current_program_back_button')), findsOneWidget);

    // 2. Hero Header (Node 76:2790)
    expect(find.text('ACTIVE TRACK'), findsOneWidget);
    expect(find.text('Communication & Public Speaking'), findsOneWidget);
    expect(find.textContaining('Master the art of expression'), findsOneWidget);

    // 3. Progress Card (Node 76:2802)
    expect(find.text('Track Progress'), findsOneWidget);
    expect(find.text('12 of 24 classes completed'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('Basics'), findsOneWidget);
    expect(find.text('Storytelling'), findsOneWidget);
    expect(find.text('Debate'), findsOneWidget);
    expect(find.text('Final Pitch'), findsOneWidget);

    // 4. Bento Grid (Node 76:2839)
    // Next Live Class card (76:2840): icon, badge, title, time — no CTA button in Figma
    expect(find.text('Speaking With Confidence'), findsOneWidget);
    expect(find.text('Tomorrow'), findsOneWidget);
    // NOTE: 'join_next_live_class_button' was removed — not present in Figma node 76:2840

    expect(find.text('Recent Assignments'), findsOneWidget);
    expect(find.text('2 Pending'), findsOneWidget);
    expect(find.text('Record a 1-min intro'), findsOneWidget);
    expect(find.text('Due Today'), findsOneWidget);
    expect(find.byKey(const Key('view_all_tasks_button')), findsOneWidget);

    // 5. Skills Acquired (Node 76:2880)
    expect(find.text('Skills in Focus'), findsOneWidget);
    expect(find.text('Confidence'), findsOneWidget);
    expect(find.text('Expression'), findsOneWidget);
    expect(find.text('Dialogue'), findsOneWidget);
  });
}
