import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/features/home/widgets/featured_carousel.dart';
import 'package:corpfinity_employee_app/data/models/carousel_item.dart';

void main() {
  group('FeaturedCarousel', () {
    final testItems = [
      const CarouselItem(
        title: 'Item 1',
        description: 'Description 1',
      ),
      const CarouselItem(
        title: 'Item 2',
        description: 'Description 2',
      ),
      const CarouselItem(
        title: 'Item 3',
        description: 'Description 3',
      ),
    ];

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: testItems,
            ),
          ),
        ),
      );

      // Verify the widget renders
      expect(find.byType(FeaturedCarousel), findsOneWidget);
      
      // Verify first item is displayed
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
    });

    testWidgets('displays pagination indicators', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: testItems,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify pagination indicators are present (3 items = 3 indicators)
      final indicators = find.byType(AnimatedContainer);
      expect(indicators, findsWidgets);
    });

    testWidgets('swipe gesture changes page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: testItems,
              autoAdvanceDuration: const Duration(seconds: 100), // Disable auto-advance for test
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify first item is displayed
      expect(find.text('Item 1'), findsOneWidget);

      // Swipe left to go to next item
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Verify second item is displayed
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('onItemChanged callback is called', (WidgetTester tester) async {
      int? changedIndex;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: testItems,
              autoAdvanceDuration: const Duration(seconds: 100),
              onItemChanged: (index) {
                changedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Swipe to next item
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Verify callback was called with correct index
      expect(changedIndex, 1);
    });

    testWidgets('handles empty items list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: [],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should render without errors but show nothing
      expect(find.byType(FeaturedCarousel), findsOneWidget);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('tap on carousel item triggers callback', (WidgetTester tester) async {
      bool tapped = false;
      
      final itemsWithCallback = [
        CarouselItem(
          title: 'Tappable Item',
          description: 'Tap me',
          onTap: () {
            tapped = true;
          },
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FeaturedCarousel(
              items: itemsWithCallback,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the carousel item
      await tester.tap(find.text('Tappable Item'));
      await tester.pumpAndSettle();

      // Verify callback was triggered
      expect(tapped, true);
    });
  });
}
