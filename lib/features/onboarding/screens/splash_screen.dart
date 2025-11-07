import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';
import 'package:corpfinity_employee_app/core/constants/typography.dart';
import 'package:corpfinity_employee_app/features/auth/providers/auth_provider.dart';

/// SplashScreen displays the app logo with fade-in animation
/// and automatically transitions to login or home after 2 seconds.
/// 
/// Features:
/// - Full-screen gradient background (Calm Blue → Soft Green)
/// - Centered logo with fade-in animation (0 → 100% opacity, 800ms)
/// - Tagline "Wellness in 1–5 minutes"
/// - Auto-transition after 2 seconds based on authentication status
/// - If authenticated → navigate to /home
/// - If not authenticated → navigate to /auth/signin
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade-in animation (800ms duration)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start the fade-in animation
    _animationController.forward();

    // Auto-transition after 2 seconds based on authentication status
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isAuthenticated = await authProvider.checkAuthStatus();
        
        if (mounted) {
          if (isAuthenticated) {
            context.go('/home');
          } else {
            context.go('/auth/signin');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.splashGradient,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo placeholder - can be replaced with actual logo image
                _buildLogoPlaceholder(),
                const SizedBox(height: 24),
                // Tagline
                Text(
                  'Wellness in 1–5 minutes',
                  style: AppTypography.headingLarge.copyWith(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a placeholder logo widget
  /// Replace this with Image.asset() when actual logo is available
  Widget _buildLogoPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.favorite,
          size: 60,
          color: AppColors.calmBlue,
        ),
      ),
    );
  }
}
