import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/utils/responsive_helper.dart';
import 'parallax_background.dart';
import 'animated_profile_header.dart';
import 'animated_progress_indicator.dart';

/// AnimatedHeroSection is the prominent top section of the homescreen featuring
/// parallax effects, gradient background, and smooth animations.
/// 
/// Features:
/// - Parallax background with gradient (moves at 50% scroll speed)
/// - Fade-in animation on load (300-500ms duration)
/// - Occupies 30-40% of viewport height
/// - Integrates profile header, level badge, and progress indicator
/// 
/// Requirements: 1.1, 3.1, 3.4
class AnimatedHeroSection extends StatefulWidget {
  /// User's display name
  final String userName;
  
  /// URL for user's profile image (optional)
  final String? profileImageUrl;
  
  /// Progress value from 0.0 to 1.0
  final double progressValue;
  
  /// User's current level
  final int currentLevel;
  
  /// Scroll controller for parallax effect integration
  final ScrollController scrollController;
  
  /// Whether parallax effect is enabled
  final bool enableParallax;
  
  /// Duration for fade-in animation
  final Duration fadeInDuration;

  const AnimatedHeroSection({
    super.key,
    required this.userName,
    this.profileImageUrl,
    required this.progressValue,
    required this.currentLevel,
    required this.scrollController,
    this.enableParallax = true,
    this.fadeInDuration = const Duration(milliseconds: 400),
  });

  @override
  State<AnimatedHeroSection> createState() => _AnimatedHeroSectionState();
}

class _AnimatedHeroSectionState extends State<AnimatedHeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize fade-in animation controller
    _fadeController = AnimationController(
      duration: widget.fadeInDuration,
      vsync: this,
    );
    
    // Create fade animation with ease-out curve
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    
    // Start fade-in animation
    _fadeController.forward();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Requirement 16.3: Check for reduced motion preference
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      // Skip animation and show content immediately
      _fadeController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate hero section height (30-40% of viewport)
    final screenHeight = MediaQuery.of(context).size.height;
    final heroHeight = _calculateHeroHeight(screenHeight);
    
    // Requirement 16.2: Semantic labels for hero section
    return Semantics(
      label: 'Profile header. ${widget.userName}, Level ${widget.currentLevel}',
      hint: 'Your current progress and level information',
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SizedBox(
        height: heroHeight,
        child: ParallaxBackground(
          scrollController: widget.scrollController,
          gradientColors: const [
            AppColors.calmBlue,
            AppColors.softGreen,
          ],
          parallaxFactor: 0.5,
          enableParallax: widget.enableParallax,
          child: Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getScreenPadding(context),
            ),
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile header with avatar and level badge
                          AnimatedProfileHeader(
                            userName: widget.userName,
                            profileImageUrl: widget.profileImageUrl,
                            currentLevel: widget.currentLevel,
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          // Animated progress indicator
                          AnimatedProgressIndicator(
                            progress: widget.progressValue,
                            currentLevel: widget.currentLevel,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  /// Calculate hero section height based on screen size
  /// Returns 30-40% of viewport height
  double _calculateHeroHeight(double screenHeight) {
    final screenSize = ResponsiveHelper.getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        // 35% of viewport on small screens
        return screenHeight * 0.35;
      case ScreenSize.medium:
        // 33% of viewport on medium screens
        return screenHeight * 0.33;
      case ScreenSize.large:
        // 30% of viewport on large screens
        return screenHeight * 0.30;
    }
  }
}
