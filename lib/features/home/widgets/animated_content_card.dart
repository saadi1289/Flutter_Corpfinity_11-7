import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/dimensions.dart';

/// AnimatedContentCard is a reusable card wrapper that provides entrance
/// animations and interactive effects for content cards.
///
/// Features:
/// - Slide-up entrance animation with fade-in
/// - Staggered animation support with configurable delay
/// - Hover scale effect (105%) on desktop/web platforms
/// - Elevation shadow transition on hover (200ms)
/// - Ripple effect on tap using InkWell
/// - Press state animation for mobile devices
/// - Platform detection to switch between hover and touch behavior
/// - Uses VisibilityDetector to trigger animations when cards become visible
///
/// Requirements: 1.2, 1.4, 4.1, 4.2, 4.3, 4.4, 4.5, 5.1, 15.1
class AnimatedContentCard extends StatefulWidget {
  /// The child widget to be wrapped with animations
  final Widget child;
  
  /// Stagger delay in milliseconds for entrance animation
  /// Default is 0ms, typically set to 100ms increments for sequential cards
  final int animationDelay;
  
  /// Callback when the card is tapped
  final VoidCallback? onTap;
  
  /// Whether to enable hover effects (scale and elevation)
  /// Default is true, automatically disabled on touch-only devices
  final bool enableHoverEffect;
  
  /// Key for VisibilityDetector to track when card becomes visible
  final Key? visibilityKey;

  const AnimatedContentCard({
    super.key,
    required this.child,
    this.animationDelay = 0,
    this.onTap,
    this.enableHoverEffect = true,
    this.visibilityKey,
  });

  @override
  State<AnimatedContentCard> createState() => _AnimatedContentCardState();
}

class _AnimatedContentCardState extends State<AnimatedContentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasAnimated = false;

  // Platform detection for hover vs touch behavior
  bool get _supportsHover => !kIsWeb && (defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with 300ms duration for entrance
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Fade-in animation from 0 to 1
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Slide-up animation from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // Start 10% below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Requirement 16.3: Check for reduced motion preference
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion && !_hasAnimated) {
      // Skip animation and show content immediately
      _controller.value = 1.0;
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_hasAnimated) return;
    
    _hasAnimated = true;
    
    // Apply stagger delay if specified
    if (widget.animationDelay > 0) {
      Future.delayed(Duration(milliseconds: widget.animationDelay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // Trigger animation when at least 10% of the card is visible
    if (info.visibleFraction > 0.1) {
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Requirement 16.2: Semantic labels for interactive elements
    return Semantics(
      button: widget.onTap != null,
      enabled: widget.onTap != null,
      child: VisibilityDetector(
        key: widget.visibilityKey ?? Key('animated_card_${widget.hashCode}'),
        onVisibilityChanged: _onVisibilityChanged,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildInteractiveCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard() {
    // Determine if hover effects should be enabled based on platform
    final shouldEnableHover = widget.enableHoverEffect && _supportsHover;

    return MouseRegion(
      onEnter: shouldEnableHover ? (_) => _setHovered(true) : null,
      onExit: shouldEnableHover ? (_) => _setHovered(false) : null,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => _setPressed(true) : null,
        onTapUp: widget.onTap != null ? (_) => _setPressed(false) : null,
        onTapCancel: widget.onTap != null ? () => _setPressed(false) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.diagonal3Values(_getScale(), _getScale(), 1.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
              boxShadow: _buildShadow(),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
                // Requirement 5.1: Ripple effect originates from tap point with 300ms duration
                splashFactory: InkRipple.splashFactory,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setHovered(bool value) {
    if (mounted) {
      setState(() {
        _isHovered = value;
      });
    }
  }

  void _setPressed(bool value) {
    if (mounted) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  double _getScale() {
    // Press state takes priority over hover
    if (_isPressed) {
      return 0.98; // Slight scale down on press for mobile
    }
    
    // Hover scale effect (105%) on desktop
    if (_isHovered && widget.enableHoverEffect && _supportsHover) {
      return 1.05;
    }
    
    return 1.0;
  }

  List<BoxShadow> _buildShadow() {
    // Enhanced shadow on hover
    if (_isHovered && widget.enableHoverEffect && _supportsHover) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 16.0,
          offset: const Offset(0, 4),
        ),
      ];
    }
    
    // Default shadow (elevation 2)
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
