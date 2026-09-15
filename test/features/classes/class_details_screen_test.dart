import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/classes/domain/entities/class_entity.dart';
import 'package:truelearn/features/classes/presentation/screens/class_details_screen.dart';

void main() {
  Widget createSubject({ClassEntity? session}) {
    return ProviderScope(
      child: MaterialApp(
        home: ClassDetailsScreen(
          classId: session?.id ?? 'test_class_1',
          session: session,
        ),
      ),
    );
  }

  testWidgets('renders Figma 76:2063 Back to My Classes header and components', (tester) async {
    const session = ClassEntity(
      id: 'test_1',
      title: 'Speaking With Confidence',
      subject: 'Communication & Public Speaking',
      status: 'SCHEDULED',
      teacherName: 'Sarah M.',
    );

    await tester.pumpWidget(createSubject(session: session));
    await tester.pumpAndSettle();

    // Verify Back navigation header
    expect(find.text('Back to My Classes'), findsOneWidget);
    expect(find.byKey(const Key('back_to_my_classes_button')), findsOneWidget);

    // Verify Title & Badges
    expect(find.text('COMMUNICATION & PUBLIC SPEAKING'), findsOneWidget);
    expect(find.text('Speaking With Confidence'), findsOneWidget);
    expect(find.text('STARTING SOON'), findsOneWidget);

    // Verify Quick Info Grid
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('7:00 PM - 7:45 PM'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('45 Minutes'), findsOneWidget);
    expect(find.text('Teacher'), findsOneWidget);
    expect(find.text('Sarah M.'), findsOneWidget);

    // Verify Focus and Practice sections
    expect(find.text("Today's Focus"), findsOneWidget);
    expect(find.text("What We'll Practice"), findsOneWidget);
    expect(find.textContaining('Voice'), findsOneWidget);
    expect(find.textContaining('Clear'), findsOneWidget);
    expect(find.text('Confidence'), findsOneWidget);
    expect(find.text('Presentation'), findsOneWidget);

    // Verify Action CTA
    expect(find.text('CONTINUE TO LIVE CLASS'), findsOneWidget);
    expect(find.textContaining('Class is starting in 18 minutes'), findsOneWidget);
  });

  testWidgets('tapping continue to live class triggers navigation to class preview', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    final ctaButton = find.byKey(const Key('continue_to_live_class_button'));
    await tester.scrollUntilVisible(ctaButton, 200, scrollable: find.byType(Scrollable));
    expect(ctaButton, findsOneWidget);

    await tester.tap(ctaButton);
    await tester.pump();
  });
}
