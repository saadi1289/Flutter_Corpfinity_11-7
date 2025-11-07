import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/core/utils/responsive_layout_manager.dart';

void main() {
  group('ResponsiveLayoutManager', () {
    testWidgets('returns 1 column for mobile screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.gridColumns, 1);
                    expect(layoutManager.isMobile, true);
                    expect(layoutManager.isTablet, false);
                    expect(layoutManager.isDesktop, false);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('returns 2 columns for tablet screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 1024)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.gridColumns, 2);
                    expect(layoutManager.isMobile, false);
                    expect(layoutManager.isTablet, true);
                    expect(layoutManager.isDesktop, false);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('returns 3 columns for desktop screens', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.gridColumns, 3);
                    expect(layoutManager.isMobile, false);
                    expect(layoutManager.isTablet, false);
                    expect(layoutManager.isDesktop, true);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('calculates hero section height correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    // Mobile: 35% of 800 = 280
                    expect(layoutManager.heroSectionHeight, 280.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('adjusts text style for different screen sizes', (tester) async {
      const baseStyle = TextStyle(fontSize: 16.0);
      
      // Mobile
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    final responsiveStyle = layoutManager.getResponsiveTextStyle(baseStyle);
                    expect(responsiveStyle.fontSize, 16.0); // Base size
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      // Tablet
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 1024)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    final responsiveStyle = layoutManager.getResponsiveTextStyle(baseStyle);
                    expect(responsiveStyle.fontSize, 18.0); // +2px
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      // Desktop
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    final responsiveStyle = layoutManager.getResponsiveTextStyle(baseStyle);
                    expect(responsiveStyle.fontSize, 20.0); // +4px
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('clamps font size to min/max constraints for body text', (tester) async {
      const smallBodyStyle = TextStyle(fontSize: 10.0); // Body text (<=18px)
      const largeBodyStyle = TextStyle(fontSize: 18.0); // Body text at upper limit
      const headingStyle = TextStyle(fontSize: 30.0); // Heading text (>18px)
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    
                    // Small body font should be clamped to min (14px)
                    final smallResponsive = layoutManager.getResponsiveTextStyle(smallBodyStyle);
                    expect(smallResponsive.fontSize, 14.0);
                    
                    // Large body font (18px + 4px = 22px) should stay within max (24px)
                    final largeBodyResponsive = layoutManager.getResponsiveTextStyle(largeBodyStyle);
                    expect(largeBodyResponsive.fontSize, 22.0);
                    
                    // Heading text should not be clamped (30px + 4px = 34px)
                    final headingResponsive = layoutManager.getResponsiveTextStyle(headingStyle);
                    expect(headingResponsive.fontSize, 34.0);
                    
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('provides correct content max width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(1400, 900)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    // Desktop should cap at 600px
                    expect(layoutManager.contentMaxWidth, 600.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('detects orientation changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Landscape: width > height
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 600)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.isLandscape, true);
                    expect(layoutManager.isPortrait, false);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('provides correct avatar sizes', (tester) async {
      // Mobile
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.avatarSize, 64.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );

      // Tablet/Desktop
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(800, 1024)),
                child: Builder(
                  builder: (context) {
                    final layoutManager = ResponsiveLayoutManager(context);
                    expect(layoutManager.avatarSize, 80.0);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });

    testWidgets('context extension works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return MediaQuery(
                data: const MediaQueryData(size: Size(400, 800)),
                child: Builder(
                  builder: (context) {
                    // Test extension method
                    final layoutManager = context.layout;
                    expect(layoutManager.gridColumns, 1);
                    expect(layoutManager.isMobile, true);
                    return const SizedBox();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  });
}
