import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/features/classes/presentation/screens/live_classroom_screen.dart';

void main() {
  testWidgets('LiveClassroomScreen renders all Figma components accurately', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LiveClassroomScreen(classId: 'cls_001'),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Subtitle
    expect(find.text('Public Speaking: Module 3'), findsOneWidget);
    expect(find.text('Communication Track'), findsOneWidget);

    // Verify LIVE badge
    expect(find.text('LIVE'), findsOneWidget);

    // Verify Teacher Stage
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('Instructor'), findsOneWidget);

    // Verify Participants Carousel
    expect(find.text('You'), findsOneWidget);
    expect(find.text('Alex R.'), findsOneWidget);
    expect(find.text('Mia S.'), findsOneWidget);
    expect(find.text('+9 Others'), findsOneWidget);

    // Verify Control Bar Buttons
    expect(find.byKey(const Key('live_classroom_mic_button')), findsOneWidget);
    expect(find.byKey(const Key('live_classroom_camera_button')), findsOneWidget);
    expect(find.byKey(const Key('live_classroom_leave_button')), findsOneWidget);
    expect(find.text('Leave'), findsOneWidget);
  });
}
