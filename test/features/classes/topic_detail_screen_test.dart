import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:truelearn/features/classes/presentation/screens/topic_detail_screen.dart';

void main() {
  testWidgets('TopicDetailScreen renders all Figma Node 76:2930 elements accurately', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/topic',
      routes: [
        GoRoute(
          path: '/topic',
          builder: (context, state) => const TopicDetailScreen(),
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

    // 1. TopAppBar verification
    expect(find.byKey(const Key('topic_detail_back_button')), findsOneWidget);
    expect(find.byType(Image), findsWidgets); // TrueLern logo and Hero illustration

    // 2. Hero Section
    expect(find.text('Communication'), findsOneWidget);
    expect(find.text('Speaking With Confidence'), findsOneWidget);
    expect(
      find.text(
        'Learn techniques to project your voice, overcome\n'
        'stage fright, and deliver your message with clarity\n'
        'and impact.',
      ),
      findsOneWidget,
    );

    // 3. Live Class Card
    expect(find.text('Live Class'), findsOneWidget);
    expect(find.text('Tomorrow, 7:00 PM'), findsOneWidget);
    expect(
      find.text('Join Instructor Sarah for an interactive session on\nvocal projection techniques.'),
      findsOneWidget,
    );

    // 4. Practice Card
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Self-paced modules'), findsOneWidget);
    expect(find.text('Voice'), findsOneWidget);
    expect(find.text('Poise'), findsOneWidget);
    expect(find.text('Clarity'), findsOneWidget);
    expect(find.text('Start Practice'), findsOneWidget);

    // 5. Assignment Card
    expect(find.text('Assignment'), findsOneWidget);
    expect(find.text('Due in 3 days'), findsOneWidget);
    expect(
      find.text('Record a 2-minute reflection on a recent\nconversation where you felt confident.'),
      findsOneWidget,
    );
    expect(find.text('Submit Reflection'), findsOneWidget);

    // 6. Topic Progress Card
    expect(find.text('Topic Progress'), findsOneWidget);
    expect(find.text('Keep it up!'), findsOneWidget);
    expect(find.textContaining('64', findRichText: true), findsWidgets);
    expect(find.textContaining('%', findRichText: true), findsWidgets);
    expect(find.text('Completed'), findsOneWidget);

    // 7. Verify SVGs are present
    expect(find.byType(SvgPicture), findsWidgets);
  });
}
