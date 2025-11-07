import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/activities/providers/wellness_pillar_provider.dart';
import 'features/activities/providers/activity_provider.dart';
import 'features/activities/providers/activity_guide_provider.dart';
import 'features/progress/providers/progress_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/challenges/providers/challenge_flow_provider.dart';

/// Root application widget
class CorpfinityApp extends StatelessWidget {
  const CorpfinityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (context) => ProfileProvider(
            context.read<AuthProvider>(),
          ),
          update: (context, authProvider, previous) =>
              previous ?? ProfileProvider(authProvider),
        ),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => WellnessPillarProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => ActivityGuideProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeFlowProvider()),
      ],
      child: MaterialApp.router(
        title: 'Corpfinity Wellness',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
