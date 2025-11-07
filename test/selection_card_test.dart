import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/widgets/selection_card.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('SelectionCard Widget Tests', () {
    testWidgets('renders with label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionCard(
              label: 'Test Option',
              icon: Icons.star,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Option'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('shows unselected state styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionCard(
              label: 'Unselected',
              icon: Icons.home,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, AppColors.white);
    });

    testWidgets('shows selected state styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionCard(
              label: 'Selected',
              icon: Icons.home,
              isSelected: true,
              onTap: () {},
              accentColor: AppColors.calmBlue,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.color, AppColors.calmBlue);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionCard(
              label: 'Tap Me',
              icon: Icons.touch_app,
              isSelected: false,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SelectionCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('has minimum touch target size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectionCard(
              label: 'Small',
              icon: Icons.circle,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final constrainedBoxes = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      
      // Find the ConstrainedBox with our specific constraints
      final selectionCardConstraints = constrainedBoxes.firstWhere(
        (box) => box.constraints.minHeight == 44.0 && box.constraints.minWidth == 44.0,
      );
      
      expect(selectionCardConstraints.constraints.minHeight, 44.0);
      expect(selectionCardConstraints.constraints.minWidth, 44.0);
    });
  });
}
