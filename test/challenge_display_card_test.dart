import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/widgets/challenge_display_card.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('ChallengeDisplayCard Widget Tests', () {
    testWidgets('renders with challenge text', (WidgetTester tester) async {
      const testChallenge = 'Take a 5-minute mindful breathing break';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: testChallenge,
            ),
          ),
        ),
      );

      // Wait for fade-in animation to complete
      await tester.pumpAndSettle();

      expect(find.text(testChallenge), findsOneWidget);
    });

    testWidgets('has minimum height of 150px', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Short text',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(container.constraints?.minHeight, 150);
    });

    testWidgets('has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Test challenge',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, AppColors.lightGray);
      expect(decoration.border, isA<Border>());
      
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.calmBlue);
      expect(border.top.width, 1);
    });

    testWidgets('has 24px padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Test challenge',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );

      expect(container.padding, const EdgeInsets.all(24));
    });

    testWidgets('text is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Centered text',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Centered text'));
      expect(text.textAlign, TextAlign.center);
    });

    testWidgets('fades in on display', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Fade in test',
            ),
          ),
        ),
      );

      // Initially, opacity should be 0 or very low
      final fadeTransition = tester.widget<FadeTransition>(
        find.byType(FadeTransition),
      );
      expect(fadeTransition.opacity.value, lessThan(0.1));

      // After animation completes, opacity should be 1
      await tester.pumpAndSettle();
      expect(fadeTransition.opacity.value, 1.0);
    });
  });
}
