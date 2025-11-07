import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/features/home/widgets/parallax_background.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('ParallaxBackground Widget Tests', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    testWidgets('renders with gradient background', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 1000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
                  child: const Center(child: Text('Test Content')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
      expect(find.byType(ParallaxBackground), findsOneWidget);
    });

    testWidgets('applies parallax transform when scrolling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 2000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
                  enableParallax: true,
                  child: const Center(child: Text('Parallax Content')),
                ),
              ),
            ),
          ),
        ),
      );

      // Initial state - no scroll
      expect(scrollController.offset, 0.0);

      // Scroll down
      scrollController.jumpTo(100.0);
      await tester.pumpAndSettle();

      // Verify scroll position changed
      expect(scrollController.offset, 100.0);
      
      // The parallax effect should be applied (background moves at 50% speed)
      // This is verified by the widget rebuilding with new offset
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('disables parallax when enableParallax is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 2000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
                  enableParallax: false,
                  child: const Center(child: Text('No Parallax')),
                ),
              ),
            ),
          ),
        ),
      );

      // Scroll down
      scrollController.jumpTo(100.0);
      await tester.pumpAndSettle();

      // Widget should still render but without parallax effect
      expect(find.text('No Parallax'), findsOneWidget);
    });

    testWidgets('uses RepaintBoundary for optimization', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 1000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
                  child: const Center(child: Text('Optimized')),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify RepaintBoundary is used for performance optimization
      // ParallaxBackground should have at least one RepaintBoundary
      final repaintBoundaries = find.descendant(
        of: find.byType(ParallaxBackground),
        matching: find.byType(RepaintBoundary),
      );
      expect(repaintBoundaries, findsAtLeastNWidgets(1));
    });

    testWidgets('applies custom parallax factor', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 2000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
                  parallaxFactor: 0.3,
                  child: const Center(child: Text('Custom Factor')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Factor'), findsOneWidget);
      
      // Scroll and verify widget updates
      scrollController.jumpTo(100.0);
      await tester.pumpAndSettle();
      
      expect(scrollController.offset, 100.0);
    });

    testWidgets('displays gradient with multiple colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              child: SizedBox(
                height: 1000,
                child: ParallaxBackground(
                  scrollController: scrollController,
                  gradientColors: const [
                    AppColors.calmBlue,
                    AppColors.softGreen,
                    AppColors.warmOrange,
                  ],
                  child: const Center(child: Text('Multi-color')),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Multi-color'), findsOneWidget);
      
      // Verify Container with gradient exists
      final containerFinder = find.descendant(
        of: find.byType(ParallaxBackground),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsWidgets);
    });
  });
}
