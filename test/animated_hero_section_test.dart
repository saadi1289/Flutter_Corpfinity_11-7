import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/features/home/widgets/animated_hero_section.dart';

void main() {
  group('AnimatedHeroSection', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      final scrollController = ScrollController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroSection(
              userName: 'Test User',
              profileImageUrl: null,
              progressValue: 0.5,
              currentLevel: 5,
              scrollController: scrollController,
            ),
          ),
        ),
      );

      // Verify the widget renders
      expect(find.byType(AnimatedHeroSection), findsOneWidget);
      
      // Verify user name is displayed
      expect(find.text('Test User'), findsOneWidget);
      
      // Verify level badge is displayed
      expect(find.text('Level 5'), findsOneWidget);
      
      scrollController.dispose();
    });

    testWidgets('displays progress indicator', (WidgetTester tester) async {
      final scrollController = ScrollController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroSection(
              userName: 'Test User',
              profileImageUrl: null,
              progressValue: 0.75,
              currentLevel: 3,
              scrollController: scrollController,
            ),
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle();

      // Verify progress text is displayed
      expect(find.text('Level Progress'), findsOneWidget);
      
      scrollController.dispose();
    });

    testWidgets('fade-in animation works', (WidgetTester tester) async {
      final scrollController = ScrollController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedHeroSection(
              userName: 'Test User',
              profileImageUrl: null,
              progressValue: 0.5,
              currentLevel: 5,
              scrollController: scrollController,
              fadeInDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
      );

      // Initial frame - should have FadeTransition
      expect(find.byType(FadeTransition), findsOneWidget);
      
      // Wait for animation to complete
      await tester.pumpAndSettle();
      
      // Widget should still be visible after animation
      expect(find.byType(AnimatedHeroSection), findsOneWidget);
      
      scrollController.dispose();
    });
  });
}
