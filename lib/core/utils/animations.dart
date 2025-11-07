import 'package:flutter/material.dart';

/// AppAnimations provides animation constants, durations, curves,
/// and helper builders for consistent animations throughout the app.
class AppAnimations {
  // Animation Durations
  static const Duration splashFadeIn = Duration(milliseconds: 800);
  static const Duration slideTransition = Duration(milliseconds: 300);
  static const Duration fadeTransition = Duration(milliseconds: 250);
  static const Duration bounceAnimation = Duration(milliseconds: 200);
  static const Duration confettiDuration = Duration(milliseconds: 1000);
  static const Duration progressBarAnimation = Duration(milliseconds: 800);
  // Minimal, responsive tap feedback
  static const Duration cardTapAnimation = Duration(milliseconds: 160);
  static const Duration badgeUnlockAnimation = Duration(milliseconds: 600);

  // Animation Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideInCurve = Curves.easeOut;
  static const Curve slideOutCurve = Curves.easeIn;
  static const Curve fadeCurve = Curves.easeInOut;
  static const Curve progressCurve = Curves.easeInOutCubic;

  // Scale Animation Values
  static const double scaleMin = 0.9;
  static const double scaleNormal = 1.0;
  static const double scaleMax = 1.2;
  // Subtle scale to avoid distracting motion
  static const double cardTapScale = 0.98;

  // Private constructor to prevent instantiation
  AppAnimations._();

  /// Creates a slide transition builder for screen navigation (300ms)
  /// 
  /// The slide direction can be customized using [begin] offset.
  /// Default slides from right to left.
  /// 
  /// Example:
  /// ```dart
  /// GoRoute(
  ///   path: '/home',
  ///   pageBuilder: (context, state) => CustomTransitionPage(
  ///     child: HomeScreen(),
  ///     transitionsBuilder: AppAnimations.slideTransitionBuilder(),
  ///   ),
  /// )
  /// ```
  static Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
      slideTransitionBuilder({
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Curve curve = slideInCurve,
  }) {
    return (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    };
  }

  /// Creates a fade transition builder for element visibility changes (250ms)
  /// 
  /// Example:
  /// ```dart
  /// GoRoute(
  ///   path: '/profile',
  ///   pageBuilder: (context, state) => CustomTransitionPage(
  ///     child: ProfileScreen(),
  ///     transitionsBuilder: AppAnimations.fadeTransitionBuilder(),
  ///   ),
  /// )
  /// ```
  static Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
      fadeTransitionBuilder({
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    Curve curve = fadeCurve,
  }) {
    return (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: beginOpacity, end: endOpacity).chain(
        CurveTween(curve: curve),
      );
      final opacityAnimation = animation.drive(tween);

      return FadeTransition(
        opacity: opacityAnimation,
        child: child,
      );
    };
  }

  /// Creates a combined slide and fade transition builder
  /// 
  /// Useful for more polished screen transitions.
  static Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
      slideFadeTransitionBuilder({
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return (context, animation, secondaryAnimation, child) {
      final slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: slideInCurve),
      );
      final fadeTween = Tween(begin: beginOpacity, end: endOpacity).chain(
        CurveTween(curve: fadeCurve),
      );

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    };
  }

  /// Creates a bounce animation controller for chips and interactive elements
  /// 
  /// Returns an AnimationController configured for bounce effect.
  /// The controller animates from [scaleMin] (0.9) to [scaleNormal] (1.0).
  /// 
  /// Example:
  /// ```dart
  /// class _ChipState extends State<Chip> with SingleTickerProviderStateMixin {
  ///   late AnimationController _controller;
  ///   late Animation<double> _scaleAnimation;
  /// 
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     _controller = AppAnimations.createBounceController(this);
  ///     _scaleAnimation = AppAnimations.createBounceAnimation(_controller);
  ///   }
  /// 
  ///   void _onTap() {
  ///     AppAnimations.playBounceAnimation(_controller);
  ///   }
  /// }
  /// ```
  static AnimationController createBounceController(TickerProvider vsync) {
    return AnimationController(
      duration: bounceAnimation,
      vsync: vsync,
    );
  }

  /// Creates a bounce scale animation from the controller
  /// 
  /// Animates from [scaleMin] (0.9) to [scaleNormal] (1.0) with bounce curve.
  static Animation<double> createBounceAnimation(AnimationController controller) {
    return Tween<double>(
      begin: scaleMin,
      end: scaleNormal,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: bounceCurve,
      ),
    );
  }

  /// Plays the bounce animation
  /// 
  /// Resets the controller and plays the animation forward.
  static Future<void> playBounceAnimation(AnimationController controller) async {
    controller.reset();
    await controller.forward();
  }

  /// Creates a progress bar animation controller
  /// 
  /// Returns an AnimationController configured for progress bar animations.
  /// Duration is 800ms with easeInOutCubic curve.
  /// 
  /// Example:
  /// ```dart
  /// class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  ///   late AnimationController _controller;
  ///   late Animation<double> _progressAnimation;
  /// 
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     _controller = AppAnimations.createProgressBarController(this);
  ///     _progressAnimation = AppAnimations.createProgressAnimation(
  ///       _controller,
  ///       targetProgress: 0.75,
  ///     );
  ///     _controller.forward();
  ///   }
  /// }
  /// ```
  static AnimationController createProgressBarController(TickerProvider vsync) {
    return AnimationController(
      duration: progressBarAnimation,
      vsync: vsync,
    );
  }

  /// Creates a progress animation from 0 to target progress value
  /// 
  /// [targetProgress] should be between 0.0 and 1.0
  static Animation<double> createProgressAnimation(
    AnimationController controller, {
    required double targetProgress,
  }) {
    return Tween<double>(
      begin: 0.0,
      end: targetProgress.clamp(0.0, 1.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: progressCurve,
      ),
    );
  }

  /// Animates progress bar to a new value
  /// 
  /// Updates the animation to animate from current value to new target.
  static Future<void> animateProgressTo(
    AnimationController controller,
    double currentProgress,
    double targetProgress,
  ) async {
    controller.reset();
    await controller.forward();
  }

  /// Creates a card tap scale animation controller
  /// 
  /// Used for interactive cards that scale down on tap.
  static AnimationController createCardTapController(TickerProvider vsync) {
    return AnimationController(
      duration: cardTapAnimation,
      vsync: vsync,
    );
  }

  /// Creates a card tap scale animation
  /// 
  /// Scales from normal (1.0) to slightly smaller (0.95) and back.
  static Animation<double> createCardTapAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: scaleNormal, end: cardTapScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: cardTapScale, end: scaleNormal)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(controller);
  }

  /// Plays the card tap animation
  static Future<void> playCardTapAnimation(AnimationController controller) async {
    controller.reset();
    await controller.forward();
  }

  /// Creates a badge unlock pulse animation controller
  /// 
  /// Used for badge unlock animations with pulse effect.
  static AnimationController createBadgeUnlockController(TickerProvider vsync) {
    return AnimationController(
      duration: badgeUnlockAnimation,
      vsync: vsync,
    );
  }

  /// Creates a badge unlock pulse animation
  /// 
  /// Scales from 0 → 1.2 → 1.0 for a pulse effect.
  static Animation<double> createBadgeUnlockAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: scaleMax)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: scaleMax, end: scaleNormal)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(controller);
  }

  /// Plays the badge unlock animation
  static Future<void> playBadgeUnlockAnimation(AnimationController controller) async {
    controller.reset();
    await controller.forward();
  }

  /// Creates a generic fade-in animation controller
  static AnimationController createFadeController(
    TickerProvider vsync, {
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? fadeTransition,
      vsync: vsync,
    );
  }

  /// Creates a fade animation
  static Animation<double> createFadeAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: fadeCurve,
      ),
    );
  }
}
