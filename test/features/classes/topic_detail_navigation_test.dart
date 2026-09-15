import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:truelearn/core/router/route_names.dart';
import 'package:truelearn/features/classes/presentation/screens/current_program_screen.dart';
import 'package:truelearn/features/classes/presentation/screens/topic_detail_screen.dart';

void main() {
  testWidgets(
      'tapping Speaking With Confidence card on CurrentProgramScreen navigates to TopicDetailScreen and back',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/parent/classes/program',
      routes: [
        GoRoute(
          path: '/parent/classes/program',
          name: AppRouteNames.currentProgram,
          builder: (context, state) => const CurrentProgramScreen(),
          routes: [
            GoRoute(
              path: 'topic',
              name: AppRouteNames.topicDetail,
              builder: (context, state) => const TopicDetailScreen(),
            ),
          ],
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

    // 1. Verify on CurrentProgramScreen
    expect(find.text('ACTIVE TRACK'), findsOneWidget);
    expect(find.text('Speaking With Confidence'), findsOneWidget);

    // 2. Tap Next Live Class / Topic card
    final cardFinder = find.byKey(const Key('current_program_next_live_class_card'));
    expect(cardFinder, findsOneWidget);
    await tester.ensureVisible(cardFinder);
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();

    // 3. Verify navigated to TopicDetailScreen
    expect(find.text('Communication'), findsOneWidget);
    expect(find.text('Speaking With Confidence'), findsWidgets);
    expect(find.text('Live Class'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Topic Progress'), findsOneWidget);

    // 4. Test Back navigation via key
    final backButtonFinder = find.byKey(const Key('topic_detail_back_button'));
    expect(backButtonFinder, findsOneWidget);
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    // 5. Verify returned to CurrentProgramScreen
    expect(find.text('ACTIVE TRACK'), findsOneWidget);
  });
}
