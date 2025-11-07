import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/features/activities/widgets/confetti_animation.dart';

void main() {
  testWidgets('ConfettiAnimation renders and completes', (WidgetTester tester) async {
    bool completed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ConfettiAnimation(
            duration: const Duration(milliseconds: 100),
            onComplete: () {
              completed = true;
            },
          ),
        ),
      ),
    );

    // Verify the widget is rendered
    expect(find.byType(ConfettiAnimation), findsOneWidget);

    // Wait for animation to complete
    await tester.pumpAndSettle(const Duration(milliseconds: 200));

    // Verify completion callback was called
    expect(completed, isTrue);
  });

  testWidgets('ConfettiAnimation can be created with default duration', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConfettiAnimation(),
        ),
      ),
    );

    expect(find.byType(ConfettiAnimation), findsOneWidget);
  });
}
