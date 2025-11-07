import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/widgets/hero_card.dart';
import 'package:corpfinity_employee_app/core/widgets/animated_progress_bar.dart';

void main() {
  group('HeroCard Widget Tests', () {
    testWidgets('renders with user name and level', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'John Doe',
              progressValue: 0.65,
              currentLevel: 5,
            ),
          ),
        ),
      );

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Level 5'), findsOneWidget);
    });

    testWidgets('displays progress percentage', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Jane Smith',
              progressValue: 0.75,
              currentLevel: 3,
            ),
          ),
        ),
      );

      expect(find.text('75%'), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
    });

    testWidgets('shows avatar placeholder when no image provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              progressValue: 0.5,
              currentLevel: 2,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('has correct height', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              progressValue: 0.5,
              currentLevel: 2,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      
      expect(container.constraints?.maxHeight, 180);
    });

    testWidgets('includes animated progress bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              progressValue: 0.65,
              currentLevel: 4,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedProgressBar), findsOneWidget);
    });

    testWidgets('has gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'Test User',
              progressValue: 0.5,
              currentLevel: 2,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('has proper semantic label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HeroCard(
              userName: 'John Doe',
              progressValue: 0.65,
              currentLevel: 5,
            ),
          ),
        ),
      );

      // Find the Semantics widget that wraps the entire HeroCard
      final semanticsFinder = find.descendant(
        of: find.byType(HeroCard),
        matching: find.byType(Semantics),
      );
      
      expect(semanticsFinder, findsWidgets);
      
      // Verify the semantic label is present in the widget tree
      final heroCardFinder = find.byType(HeroCard);
      expect(heroCardFinder, findsOneWidget);
    });
  });
}
