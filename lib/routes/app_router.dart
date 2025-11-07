import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Placeholder screens - will be implemented in later tasks
import 'package:corpfinity_employee_app/features/onboarding/screens/splash_screen.dart';
import 'package:corpfinity_employee_app/features/auth/screens/sign_up_screen.dart';
import 'package:corpfinity_employee_app/features/auth/screens/sign_in_screen.dart';
import 'package:corpfinity_employee_app/features/home/screens/home_screen.dart';
import 'package:corpfinity_employee_app/features/activities/screens/wellness_pillar_screen.dart';
import 'package:corpfinity_employee_app/features/activities/screens/activity_selection_screen.dart';
import 'package:corpfinity_employee_app/features/activities/screens/activity_guide_screen.dart';
import 'package:corpfinity_employee_app/features/activities/screens/completion_screen.dart';
import 'package:corpfinity_employee_app/features/activities/screens/activity_library_screen.dart';
import 'package:corpfinity_employee_app/features/progress/screens/progress_screen.dart';
import 'package:corpfinity_employee_app/features/profile/screens/profile_screen.dart';
import 'package:corpfinity_employee_app/features/challenges/screens/challenge_flow_screen.dart';
import 'package:corpfinity_employee_app/features/challenges/screens/elegant_challenge_creation_screen.dart';

/// Application router configuration using GoRouter
/// 
/// Defines all navigation routes for the Corpfinity Employee App
/// Initial route is set to splash screen
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Onboarding Routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth/signin',
        name: 'signin',
        builder: (context, state) => const SignInScreen(),
      ),

      // Home Route
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Challenge Routes
      GoRoute(
        path: '/challenge/create',
        name: 'challenge-create',
        builder: (context, state) => const ChallengeFlowScreen(),
      ),
      // Deprecated alias: point elegant route to the merged ChallengeFlowScreen
      GoRoute(
        path: '/challenge/elegant-create',
        name: 'elegant-challenge-create',
        builder: (context, state) => const ChallengeFlowScreen(),
      ),

      // Wellness Pillar Route
      GoRoute(
        path: '/pillars',
        name: 'pillars',
        builder: (context, state) {
          // Extract energy level from query parameters
          final energyLevel = state.uri.queryParameters['energy'];
          return WellnessPillarScreen(energyLevel: energyLevel);
        },
      ),

      // Activity Selection Route
      GoRoute(
        path: '/activities',
        name: 'activities',
        builder: (context, state) {
          // Extract pillar ID and energy level from query parameters
          final pillarId = state.uri.queryParameters['pillar'];
          final energyLevel = state.uri.queryParameters['energy'];
          return ActivitySelectionScreen(
            pillarId: pillarId,
            energyLevel: energyLevel,
          );
        },
      ),

      // Activity Guide Route (with activity ID parameter)
      GoRoute(
        path: '/activity/:id',
        name: 'activity-guide',
        builder: (context, state) {
          final activityId = state.pathParameters['id']!;
          return ActivityGuideScreen(activityId: activityId);
        },
      ),

      // Activity Completion Route
      GoRoute(
        path: '/completion',
        name: 'completion',
        builder: (context, state) {
          // Extract activity name and stats from query parameters
          final activityName = state.uri.queryParameters['activity'];
          return CompletionScreen(activityName: activityName);
        },
      ),

      // Progress Tracking Route
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressScreen(),
      ),

      // Profile Route
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Activity Library Route
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const ActivityLibraryScreen(),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
