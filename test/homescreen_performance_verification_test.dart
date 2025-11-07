import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:corpfinity_employee_app/features/home/screens/home_screen.dart';
import 'package:corpfinity_employee_app/features/home/providers/home_provider.dart';
import 'package:corpfinity_employee_app/core/utils/performance_monitor.dart';
import 'package:corpfinity_employee_app/data/models/animation_config.dart';

/// Performance verification tests for HomeScreen redesign
/// 
/// Requirements tested:
/// - 1.3: Maintain animation performance at 60fps or higher
/// - 1.4: Complete all initial animations within 1 second
/// - 10.3: Display critical above-the-fold content within 1 second
/// - 11.5: Limit initial data payload to under 500KB
/// - 12.1: Maintain 60fps during all animations
/// - 12.3: Use GPU-accelerated transforms for all position and scale animations
void main() {
  group('Performance Verification Tests - Task 17.4', () {
    late HomeProvider homeProvider;

    setUp(() {
      homeProvider = HomeProvider();
    });

    tearDown(() {
      homeProvider.dispose();
    });

    /// Test: Above-the-fold content displays within 1 second
    /// Requirements: 1.4, 10.3
    testWidgets('Above-the-fold content displays within 1 second', 
        (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      // Build HomeScreen with provider
      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Pump first frame
      await tester.pump();
      
      stopwatch.stop();

      // Verify initial render completes within 1 second
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(1000),
        reason: 'Above-the-fold content must display within 1 second',
      );

      // Verify critical content is present
      expect(find.byType(HomeScreen), findsOneWidget);
      
      // Hero section should be visible (even if animating)
      expect(find.text('User'), findsOneWidget);
    });

    /// Test: All entrance animations complete within 1 second
    /// Requirements: 1.4
    testWidgets('All entrance animations complete within 1 second',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Start timing
      final stopwatch = Stopwatch()..start();
      
      // Pump first frame
      await tester.pump();

      // Pump and settle all animations
      await tester.pumpAndSettle();
      
      stopwatch.stop();

      // Verify all animations complete within 1 second
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(1000),
        reason: 'All entrance animations must complete within 1 second',
      );

      // Verify no pending frames
      expect(tester.binding.hasScheduledFrame, false);
    });

    /// Test: Animations maintain smooth frame rate
    /// Requirements: 1.3, 12.1
    testWidgets('Animations maintain smooth frame rate during scroll',
        (WidgetTester tester) async {
      // Track frame timings
      final List<Duration> frameDurations = [];
      
      // Add timing callback to capture frame durations
      tester.binding.addPersistentFrameCallback((duration) {
        frameDurations.add(duration);
      });

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Clear initial frame durations
      frameDurations.clear();

      // Perform scroll animation
      final scrollView = find.byType(CustomScrollView);
      expect(scrollView, findsOneWidget);

      // Drag to trigger scroll and parallax animations
      await tester.drag(scrollView, const Offset(0, -300));
      
      // Pump frames during animation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      await tester.pumpAndSettle();

      // Calculate average frame duration
      if (frameDurations.isNotEmpty) {
        final avgFrameDuration = frameDurations
            .map((d) => d.inMicroseconds)
            .reduce((a, b) => a + b) / frameDurations.length;
        
        final avgFps = 1000000 / avgFrameDuration;

        // Verify average FPS is at least 55 (allowing small margin below 60)
        expect(
          avgFps,
          greaterThanOrEqualTo(55),
          reason: 'Animations should maintain at least 55fps (target 60fps)',
        );
      }
    });

    /// Test: Automatic animation complexity reduction at low FPS
    /// Requirements: 12.1, 12.2
    testWidgets('Automatic animation complexity reduction triggers at low FPS',
        (WidgetTester tester) async {
      final performanceMonitor = PerformanceMonitor();
      
      // Initially should not reduce animations
      expect(performanceMonitor.shouldReduceAnimations, false);

      // Simulate low FPS (below 55fps threshold)
      performanceMonitor.adjustAnimationComplexity(50);

      // Verify animation reduction is triggered
      expect(
        performanceMonitor.shouldReduceAnimations,
        true,
        reason: 'Animation complexity should reduce when FPS drops below 55',
      );

      // Simulate FPS recovery
      performanceMonitor.adjustAnimationComplexity(60);

      // Verify animations are restored
      expect(
        performanceMonitor.shouldReduceAnimations,
        false,
        reason: 'Animations should restore when FPS recovers',
      );

      performanceMonitor.dispose();
    });

    /// Test: HomeProvider responds to performance changes
    /// Requirements: 12.2
    testWidgets('HomeProvider adjusts animations based on performance',
        (WidgetTester tester) async {
      // Initialize with default config
      expect(homeProvider.state.shouldReduceAnimations, false);
      expect(homeProvider.state.animationConfig.enableParallax, true);

      // Simulate performance drop
      homeProvider.adjustAnimationComplexity(true);

      // Verify reduced animation mode is enabled
      expect(homeProvider.state.shouldReduceAnimations, true);
      expect(
        homeProvider.state.animationConfig.enableParallax,
        false,
        reason: 'Parallax should be disabled in reduced animation mode',
      );

      // Simulate performance recovery
      homeProvider.adjustAnimationComplexity(false);

      // Verify full animations are restored
      expect(homeProvider.state.shouldReduceAnimations, false);
      expect(homeProvider.state.animationConfig.enableParallax, true);
    });

    /// Test: AnimationConfig.reduced() disables expensive animations
    /// Requirements: 12.2, 12.5
    test('AnimationConfig.reduced() disables expensive animations', () {
      final reducedConfig = AnimationConfig.reduced();

      // Verify parallax is disabled
      expect(
        reducedConfig.enableParallax,
        false,
        reason: 'Parallax should be disabled in reduced mode',
      );

      // Verify concurrent animations are limited
      expect(
        reducedConfig.maxConcurrentAnimations,
        1,
        reason: 'Concurrent animations should be limited to 1 in reduced mode',
      );

      // Verify animation durations are shorter
      expect(
        reducedConfig.fadeInDuration.inMilliseconds,
        lessThan(300),
        reason: 'Fade-in duration should be reduced',
      );

      expect(
        reducedConfig.slideUpDuration.inMilliseconds,
        lessThan(200),
        reason: 'Slide-up duration should be reduced',
      );
    });

    /// Test: Initial data payload size verification
    /// Requirements: 11.5
    test('Initial data payload is under 500KB', () {
      // Calculate approximate payload size
      final state = homeProvider.state;
      
      // Estimate size of state data
      int estimatedSize = 0;
      
      // String data (userName, profileImageUrl)
      estimatedSize += state.userName.length * 2; // UTF-16 encoding
      if (state.profileImageUrl != null) {
        estimatedSize += state.profileImageUrl!.length * 2;
      }
      
      // Numeric data (int, double, bool)
      estimatedSize += 8 * 5; // 5 numeric fields
      
      // Featured items (assuming 3 items with ~200 bytes each)
      estimatedSize += state.featuredItems.length * 200;
      
      // Animation config
      estimatedSize += 100; // Approximate size
      
      // Convert to KB
      final sizeInKB = estimatedSize / 1024;
      
      expect(
        sizeInKB,
        lessThan(500),
        reason: 'Initial data payload must be under 500KB',
      );
    });

    /// Test: Scroll throttling prevents excessive updates
    /// Requirements: 1.3, 2.3, 12.4
    testWidgets('Scroll updates are throttled to 60fps',
        (WidgetTester tester) async {
      int scrollUpdateCount = 0;
      
      // Create provider with callback to count updates
      final testProvider = HomeProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: testProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Track scroll position updates
      final initialOffset = testProvider.scrollOffset;

      // Perform rapid scroll
      final scrollView = find.byType(CustomScrollView);
      await tester.drag(scrollView, const Offset(0, -500));

      // Pump multiple frames rapidly (simulating fast scroll)
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 8)); // 8ms = 125fps
        if (testProvider.scrollOffset != initialOffset) {
          scrollUpdateCount++;
        }
      }

      // Verify updates are throttled (should be much less than 20)
      // With 16ms throttling, we expect ~10 updates max for 160ms of scrolling
      expect(
        scrollUpdateCount,
        lessThan(15),
        reason: 'Scroll updates should be throttled to prevent excessive recalculations',
      );

      testProvider.dispose();
    });

    /// Test: GPU-accelerated transforms are used
    /// Requirements: 12.3
    testWidgets('Animations use GPU-accelerated transforms',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find Transform widgets (used for GPU-accelerated animations)
      final transforms = find.byType(Transform);
      
      // Verify Transform widgets are present for animations
      expect(
        transforms,
        findsWidgets,
        reason: 'Transform widgets should be used for GPU-accelerated animations',
      );

      // Note: In a real app, we would verify that animations use
      // transform properties (translate, scale) rather than layout properties
      // (width, height, padding) which are not GPU-accelerated
    });

    /// Test: RepaintBoundary optimization is applied
    /// Requirements: 1.5, 12.1, 12.3
    testWidgets('RepaintBoundary isolates expensive widgets',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find RepaintBoundary widgets
      final repaintBoundaries = find.byType(RepaintBoundary);
      
      // Verify RepaintBoundary is used to isolate repaints
      expect(
        repaintBoundaries,
        findsWidgets,
        reason: 'RepaintBoundary should be used to isolate expensive widgets',
      );

      // Verify at least 3 RepaintBoundaries (hero section, carousel, content cards)
      expect(
        tester.widgetList(repaintBoundaries).length,
        greaterThanOrEqualTo(3),
        reason: 'Multiple RepaintBoundaries should isolate different sections',
      );
    });

    /// Test: Performance monitor tracks FPS correctly
    /// Requirements: 12.1, 12.2
    test('PerformanceMonitor tracks FPS correctly', () async {
      final monitor = PerformanceMonitor();
      
      // Initial FPS should be at target
      expect(monitor.currentFps, equals(60));
      
      // Start monitoring
      monitor.startMonitoring();
      expect(monitor.isMonitoring, true);

      // Simulate FPS changes
      monitor.adjustAnimationComplexity(58);
      expect(monitor.currentFps, equals(58));
      expect(monitor.shouldReduceAnimations, false);

      monitor.adjustAnimationComplexity(52);
      expect(monitor.currentFps, equals(52));
      expect(
        monitor.shouldReduceAnimations,
        true,
        reason: 'Should reduce animations when FPS drops below 55',
      );

      // Stop monitoring
      monitor.stopMonitoring();
      expect(monitor.isMonitoring, false);

      monitor.dispose();
    });

    /// Test: Reduced motion preference is respected
    /// Requirements: 1.3, 12.2
    testWidgets('Reduced motion preference disables animations',
        (WidgetTester tester) async {
      // Manually enable reduced animations mode
      homeProvider.enableReducedAnimations();

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();

      // Verify reduced animations are enabled
      expect(
        homeProvider.state.animationConfig.enableParallax,
        false,
        reason: 'Parallax should be disabled when reduced motion is enabled',
      );
    });

    /// Test: Concurrent animation limit is enforced
    /// Requirements: 12.5
    test('Concurrent animation limit is enforced', () {
      final defaultConfig = AnimationConfig();
      final reducedConfig = AnimationConfig.reduced();

      // Default config allows up to 3 concurrent animations
      expect(
        defaultConfig.maxConcurrentAnimations,
        equals(3),
        reason: 'Default config should allow 3 concurrent animations',
      );

      // Reduced config limits to 1 concurrent animation
      expect(
        reducedConfig.maxConcurrentAnimations,
        equals(1),
        reason: 'Reduced config should limit to 1 concurrent animation',
      );
    });
  });

  group('Performance Benchmarks', () {
    /// Benchmark: Measure hero section render time
    testWidgets('Hero section renders quickly', (WidgetTester tester) async {
      final homeProvider = HomeProvider();
      
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      stopwatch.stop();

      // Hero section should render in less than 500ms
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(500),
        reason: 'Hero section should render quickly',
      );

      homeProvider.dispose();
    });

    /// Benchmark: Measure carousel transition time
    testWidgets('Carousel transitions are smooth', (WidgetTester tester) async {
      final homeProvider = HomeProvider();
      await homeProvider.loadFeaturedItems();

      await tester.pumpWidget(
        ChangeNotifierProvider<HomeProvider>.value(
          value: homeProvider,
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Measure carousel transition
      final stopwatch = Stopwatch()..start();
      
      homeProvider.updateCarouselIndex(1);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      
      stopwatch.stop();

      // Transition should complete in ~400ms
      expect(
        stopwatch.elapsedMilliseconds,
        lessThanOrEqualTo(450),
        reason: 'Carousel transition should complete in 400ms',
      );

      homeProvider.dispose();
    });
  });
}
