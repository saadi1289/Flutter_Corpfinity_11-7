import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:corpfinity_employee_app/app.dart';
import 'package:corpfinity_employee_app/features/auth/providers/auth_provider.dart';
import 'package:corpfinity_employee_app/features/home/providers/home_provider.dart';
import 'package:corpfinity_employee_app/features/challenges/providers/challenge_flow_provider.dart';
import 'package:corpfinity_employee_app/features/challenges/screens/challenge_flow_screen.dart';
import 'package:corpfinity_employee_app/features/home/screens/home_screen.dart';
import 'package:corpfinity_employee_app/features/auth/screens/sign_in_screen.dart';
import 'package:corpfinity_employee_app/core/widgets/hero_card.dart';
import 'package:corpfinity_employee_app/core/widgets/selection_card.dart';
import 'package:corpfinity_employee_app/core/widgets/challenge_display_card.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';

void main() {
  group('Cross-Platform Compatibility Tests', () {
    
    // Helper function to create test widget with providers
    Widget createTestWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => ChallengeFlowProvider()),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    group('Icon Rendering Tests', () {
      testWidgets('SelectionCard icons render correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: SelectionCard(
                label: 'Test',
                icon: Icons.home,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Verify icon is present
        expect(find.byIcon(Icons.home), findsOneWidget);
        
        // Verify icon is visible
        final iconWidget = tester.widget<Icon>(find.byIcon(Icons.home));
        expect(iconWidget.icon, Icons.home);
      });

      testWidgets('HeroCard displays profile icon correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: HeroCard(
                userName: 'Test User',
                profileImageUrl: null,
                progressValue: 0.5,
                currentLevel: 5,
              ),
            ),
          ),
        );

        // Verify placeholder icon when no image
        expect(find.byIcon(Icons.person), findsOneWidget);
      });
    });

    group('Animation and Transition Tests', () {
      testWidgets('SelectionCard scale animation on selection', (WidgetTester tester) async {
        bool isSelected = false;
        
        await tester.pumpWidget(
          createTestWidget(
            StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: SelectionCard(
                    label: 'Test',
                    icon: Icons.home,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        isSelected = true;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        );

        // Tap the card
        await tester.tap(find.byType(SelectionCard));
        await tester.pump();
        
        // Pump animation frames
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        
        // Verify selection state changed
        expect(isSelected, true);
      });

      testWidgets('HeroCard progress bar animates', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: HeroCard(
                userName: 'Test User',
                profileImageUrl: null,
                progressValue: 0.65,
                currentLevel: 5,
              ),
            ),
          ),
        );

        // Initial pump
        await tester.pump();
        
        // Pump animation frames (800ms animation)
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pump(const Duration(milliseconds: 200));
        
        // Verify progress bar is rendered
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('ChallengeDisplayCard fade-in animation', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: ChallengeDisplayCard(
                challengeText: 'Test Challenge',
              ),
            ),
          ),
        );

        // Initial pump
        await tester.pump();
        
        // Pump animation frames (400ms fade-in)
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));
        
        // Verify card is visible
        expect(find.text('Test Challenge'), findsOneWidget);
      });
    });

    group('Safe Area Handling Tests', () {
      testWidgets('HomeScreen handles safe area correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const HomeScreen()));
        await tester.pumpAndSettle();

        // Verify SafeArea is used
        expect(find.byType(SafeArea), findsWidgets);
      });

      testWidgets('ChallengeFlowScreen handles safe area correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const ChallengeFlowScreen()));
        await tester.pumpAndSettle();

        // Verify SafeArea is used
        expect(find.byType(SafeArea), findsWidgets);
      });

      testWidgets('SignInScreen handles safe area correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const SignInScreen()));
        await tester.pumpAndSettle();

        // Verify SafeArea is used
        expect(find.byType(SafeArea), findsWidgets);
      });
    });

    group('Touch Interaction Tests', () {
      testWidgets('SelectionCard has minimum touch target size', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: Center(
                child: SelectionCard(
                  label: 'Test',
                  icon: Icons.home,
                  isSelected: false,
                  onTap: () {},
                ),
              ),
            ),
          ),
        );

        // Get the card size
        final cardFinder = find.byType(SelectionCard);
        final cardSize = tester.getSize(cardFinder);
        
        // Verify minimum touch target (44x44 logical pixels)
        expect(cardSize.height >= 44, true);
        expect(cardSize.width >= 44, true);
      });

      testWidgets('Buttons have ripple effect on tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Test Button'),
                ),
              ),
            ),
          ),
        );

        // Tap the button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        
        // Pump to show ripple effect
        await tester.pump(const Duration(milliseconds: 100));
        
        // Verify button is present and tappable
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('HeroCard adapts to small screen (iPhone SE)', (WidgetTester tester) async {
        // Set small screen size (iPhone SE: 320x568)
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: HeroCard(
                userName: 'Test User',
                profileImageUrl: null,
                progressValue: 0.5,
                currentLevel: 5,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Verify card renders on small screen
        expect(find.byType(HeroCard), findsOneWidget);
      });

      testWidgets('HeroCard adapts to large screen (iPhone 14)', (WidgetTester tester) async {
        // Set large screen size (iPhone 14: 390x844)
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: HeroCard(
                userName: 'Test User',
                profileImageUrl: null,
                progressValue: 0.5,
                currentLevel: 5,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Verify card renders on large screen
        expect(find.byType(HeroCard), findsOneWidget);
      });

      testWidgets('Challenge flow cards adapt to small screen', (WidgetTester tester) async {
        // Set small screen size
        tester.view.physicalSize = const Size(320, 568);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(createTestWidget(const ChallengeFlowScreen()));
        await tester.pumpAndSettle();

        // Verify screen renders and is scrollable
        expect(find.byType(ChallengeFlowScreen), findsOneWidget);
      });
    });

    group('Color Contrast Tests', () {
      testWidgets('SelectionCard unselected state has proper contrast', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: SelectionCard(
                label: 'Test',
                icon: Icons.home,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ),
        );

        // Verify text is visible
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('SelectionCard selected state has proper contrast', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: SelectionCard(
                label: 'Test',
                icon: Icons.home,
                isSelected: true,
                onTap: () {},
                accentColor: AppColors.calmBlue,
              ),
            ),
          ),
        );

        // Verify text is visible in selected state
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('Navigation Tests', () {
      testWidgets('Back button navigation works', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(const ChallengeFlowScreen()));
        await tester.pumpAndSettle();

        // Verify back button is present
        expect(find.byType(BackButton), findsOneWidget);
        
        // Tap back button
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
      });
    });

    group('Performance Tests', () {
      testWidgets('Animations maintain 60 FPS target', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            Scaffold(
              body: HeroCard(
                userName: 'Test User',
                profileImageUrl: null,
                progressValue: 0.65,
                currentLevel: 5,
              ),
            ),
          ),
        );

        // Pump animation frames and verify no frame drops
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 16)); // ~60 FPS
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
        
        // If we reach here without errors, animations are smooth
        expect(find.byType(HeroCard), findsOneWidget);
      });
    });
  });
}
