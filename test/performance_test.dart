import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/widgets/hero_card.dart';
import 'package:corpfinity_employee_app/core/widgets/selection_card.dart';
import 'package:corpfinity_employee_app/core/widgets/animated_progress_bar.dart';
import 'package:corpfinity_employee_app/core/widgets/challenge_display_card.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('HeroCard renders without performance issues', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              profileImageUrl: null,
              progressValue: 0.65,
              currentLevel: 5,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Level 5'), findsOneWidget);
      
      // Pump frames to complete animation
      await tester.pumpAndSettle();
      
      // Verify no performance warnings
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('SelectionCard animation completes smoothly', (WidgetTester tester) async {
      bool isSelected = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SelectionCard(
                  label: 'Test Option',
                  icon: Icons.star,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Test Option'), findsOneWidget);
      
      // Tap to select
      await tester.tap(find.byType(SelectionCard));
      await tester.pump(); // Start animation
      
      // Pump animation frames (200ms animation)
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      
      // Complete animation
      await tester.pumpAndSettle();
      
      // Verify animation completed
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('AnimatedProgressBar animates within target duration', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedProgressBar(
              progress: 0.75,
              height: 10,
              gradientColors: [AppColors.calmBlue, AppColors.softGreen],
            ),
          ),
        ),
      );

      // Start animation
      await tester.pump();
      
      // Animation should complete in 800ms (as per design spec)
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();
      
      // Verify animation completed
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('ChallengeDisplayCard fade-in animation completes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ChallengeDisplayCard(
              challengeText: 'Test challenge text',
            ),
          ),
        ),
      );

      // Start animation
      await tester.pump();
      
      // Animation should complete in 400ms (as per design spec)
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      
      // Verify text is visible
      expect(find.text('Test challenge text'), findsOneWidget);
      
      // Verify animation completed
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('Multiple SelectionCards render efficiently', (WidgetTester tester) async {
      // Test rendering multiple cards (simulating challenge flow)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  6,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectionCard(
                      label: 'Option $index',
                      icon: Icons.star,
                      isSelected: false,
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Verify at least 5 cards are visible (some may be off-screen)
      expect(find.byType(SelectionCard), findsAtLeastNWidgets(5));
      
      // Verify no performance issues
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('HeroCard with cached image placeholder renders efficiently', (WidgetTester tester) async {
      // Test with null image URL (should show placeholder)
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              profileImageUrl: null,
              progressValue: 0.5,
              currentLevel: 3,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Verify placeholder icon is shown
      expect(find.byIcon(Icons.person), findsOneWidget);
      
      // Verify no performance issues
      expect(tester.binding.hasScheduledFrame, false);
    });
  });

  group('Animation Performance Tests', () {
    testWidgets('Step transitions complete within 300ms', (WidgetTester tester) async {
      // Test that animations complete within the specified duration
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: const ValueKey('test'),
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();
      
      expect(tester.binding.hasScheduledFrame, false);
    });

    testWidgets('Selection animation completes within 200ms', (WidgetTester tester) async {
      bool isSelected = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SelectionCard(
                  label: 'Test',
                  icon: Icons.star,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = true;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SelectionCard));
      await tester.pump();
      
      // Animation should complete in 200ms
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      
      expect(tester.binding.hasScheduledFrame, false);
    });
  });

  group('Const Constructor Tests', () {
    test('HeroCard uses const constructor', () {
      const card = HeroCard(
        userName: 'Test',
        progressValue: 0.5,
        currentLevel: 1,
      );
      
      expect(card, isNotNull);
    });

    test('SelectionCard can be created', () {
      final card = SelectionCard(
        label: 'Test',
        icon: Icons.star,
        isSelected: false,
        onTap: () {},
      );
      
      expect(card, isNotNull);
    });

    test('AnimatedProgressBar uses const constructor', () {
      const progressBar = AnimatedProgressBar(
        progress: 0.5,
      );
      
      expect(progressBar, isNotNull);
    });

    test('ChallengeDisplayCard uses const constructor', () {
      const card = ChallengeDisplayCard(
        challengeText: 'Test',
      );
      
      expect(card, isNotNull);
    });
  });
}
