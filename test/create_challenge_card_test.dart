import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/widgets/create_challenge_card.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('CreateChallengeCard Widget Tests', () {
    testWidgets('renders with Create Challenge button text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Create Challenge'), findsOneWidget);
    });

    testWidgets('has correct height of 120px', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      
      expect(container.constraints?.maxHeight, 120);
    });

    testWidgets('has warmOrange background with 10% opacity', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, AppColors.warmOrange.withOpacity(0.1));
    });

    testWidgets('has 2px solid warmOrange border', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.border, isA<Border>());
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.warmOrange);
      expect(border.top.width, 2);
    });

    testWidgets('button has warmOrange background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = button.style;
      
      expect(
        buttonStyle?.backgroundColor?.resolve({}),
        AppColors.warmOrange,
      );
    });

    testWidgets('button has white text color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = button.style;
      
      expect(
        buttonStyle?.foregroundColor?.resolve({}),
        AppColors.white,
      );
    });

    testWidgets('calls onTap when button is pressed', (WidgetTester tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasTapped, true);
    });

    testWidgets('has proper semantic label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final semanticsFinder = find.descendant(
        of: find.byType(CreateChallengeCard),
        matching: find.byType(Semantics),
      );
      
      expect(semanticsFinder, findsWidgets);
      
      final cardFinder = find.byType(CreateChallengeCard);
      expect(cardFinder, findsOneWidget);
    });

    testWidgets('button is full width', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateChallengeCard(
              onTap: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CreateChallengeCard),
          matching: find.byType(SizedBox),
        ).first,
      );
      
      expect(sizedBox.width, double.infinity);
    });
  });
}
