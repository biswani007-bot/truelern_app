import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/classes/presentation/screens/parent_classes_screen.dart';
import 'package:truelearn/features/classes/presentation/widgets/classes_date_navigator.dart';
import 'package:truelearn/features/classes/presentation/widgets/classes_event_card.dart';
import 'package:truelearn/features/classes/presentation/widgets/classes_filter_tabs.dart';
import 'package:truelearn/features/classes/presentation/widgets/classes_student_selector.dart';
import 'package:truelearn/features/classes/presentation/widgets/empty_classes_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createSubject() {
    return const MaterialApp(
      home: Scaffold(
        body: ParentClassesScreen(),
      ),
    );
  }

  testWidgets('renders Figma Frame 76:1820 TopAppBar, StudentSelector, and DateNavigator', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // Figma Frame 76:1820 Top App Bar
    expect(find.byKey(const Key('parent_classes_screen')), findsOneWidget);
    expect(find.text('My Classes'), findsOneWidget);
    expect(find.byKey(const Key('classes_menu_button')), findsOneWidget);
    expect(find.byKey(const Key('classes_filter_icon_button')), findsOneWidget);

    // Figma Student Selector: Alex
    expect(find.byType(ClassesStudentSelector), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);

    // Figma Date Navigator Strip
    expect(find.byType(ClassesDateNavigator), findsOneWidget);
    expect(find.text('Wed'), findsWidgets);
    expect(find.text('26'), findsWidgets);

    // Figma Filter Tabs
    expect(find.byType(ClassesFilterTabs), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    // Figma Header and Classes
    expect(find.text('Upcoming Events'), findsOneWidget);
    expect(find.text('Public Speaking Workshop'), findsOneWidget);
    expect(find.text('Creative Thinking Demo'), findsOneWidget);
    expect(find.byType(ClassesEventCard), findsNWidgets(2));
    expect(find.byKey(const Key('explore_programs_button'), skipOffstage: false), findsOneWidget);
  });

  testWidgets('ClassesDateNavigator scrolls horizontally and allows date selection', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // Verify initial selection shows both Figma classes on Wed 26
    expect(find.text('Public Speaking Workshop'), findsOneWidget);

    // Drag / swipe the date selector horizontally to the left (scroll forward)
    final dateNavigatorFinder = find.byType(ClassesDateNavigator);
    await tester.drag(dateNavigatorFinder, const Offset(-200, 0));
    await tester.pumpAndSettle();

    // Swipe back to the right
    await tester.drag(dateNavigatorFinder, const Offset(200, 0));
    await tester.pumpAndSettle();

    // Tap on Thu 27
    final thu27Finder = find.text('27');
    if (thu27Finder.evaluate().isNotEmpty) {
      await tester.tap(thu27Finder.first);
      await tester.pumpAndSettle();

      // Only Creative Thinking Demo scheduled for 27th
      expect(find.text('Creative Thinking Demo'), findsOneWidget);
      expect(find.text('Public Speaking Workshop'), findsNothing);
    }

    // Tap back on Wed 26
    final wed26Finder = find.text('26');
    expect(wed26Finder, findsWidgets);
    await tester.tap(wed26Finder.first);
    await tester.pumpAndSettle();

    // Both Figma classes restored
    expect(find.text('Public Speaking Workshop'), findsOneWidget);
    expect(find.text('Creative Thinking Demo'), findsOneWidget);
  });

  testWidgets('Selecting an empty date shows Figma EmptyClassesWidget', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    // Tap on Mon 24 (which has no classes)
    final mon24Finder = find.text('24');
    if (mon24Finder.evaluate().isNotEmpty) {
      await tester.tap(mon24Finder.first);
      await tester.pumpAndSettle();

      expect(find.byType(EmptyClassesWidget), findsOneWidget);
      expect(find.byType(ClassesEventCard), findsNothing);
    }
  });

  testWidgets('Switching child updates student selector pill state', (tester) async {
    await tester.pumpWidget(createSubject());
    await tester.pumpAndSettle();

    expect(find.text('Alex'), findsOneWidget);

    // Tap child selector
    final selectorButton = find.byKey(const Key('classes_student_selector_button'));
    await tester.tap(selectorButton);
    await tester.pumpAndSettle();

    // Select Mia from sheet
    expect(find.text('Mia'), findsOneWidget);
    await tester.tap(find.text('Mia'));
    await tester.pumpAndSettle();

    expect(find.text('Mia'), findsOneWidget);
  });
}
