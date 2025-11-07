import 'package:flutter/material.dart';

/// ParallaxBackground creates a depth perception effect by moving background
/// elements at a different speed than foreground elements during scrolling.
/// 
/// This widget listens to a scroll controller and applies a transform to create
/// a parallax effect where the background moves at 50% of the scroll speed.
/// 
/// Performance optimizations:
/// - Uses RepaintBoundary to isolate repaints
/// - GPU-accelerated transform operations
/// - Conditional parallax disabling based on AnimationConfig
/// 
/// Requirements: 2.1, 2.2, 2.3, 2.4, 2.5
class ParallaxBackground extends StatefulWidget {
  /// The scroll controller to listen to for parallax calculations
  final ScrollController scrollController;
  
  /// Gradient colors for the background
  final List<Color> gradientColors;
  
  /// Parallax factor - determines how much slower the background moves
  /// Default is 0.5 (50% of scroll speed)
  final double parallaxFactor;
  
  /// Child widget to display in the foreground
  final Widget child;
  
  /// Whether parallax effect is enabled
  /// When false, background moves at normal scroll speed
  final bool enableParallax;

  const ParallaxBackground({
    super.key,
    required this.scrollController,
    required this.gradientColors,
    this.parallaxFactor = 0.5,
    required this.child,
    this.enableParallax = true,
  });

  @override
  State<ParallaxBackground> createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  /// Current parallax offset calculated from scroll position
  double _parallaxOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen to scroll controller for parallax calculations
    widget.scrollController.addListener(_updateParallaxOffset);
  }

  @override
  void didUpdateWidget(ParallaxBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update listener if scroll controller changed
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_updateParallaxOffset);
      widget.scrollController.addListener(_updateParallaxOffset);
    }
  }

  @override
  void dispose() {
    // Clean up listener to prevent memory leaks
    widget.scrollController.removeListener(_updateParallaxOffset);
    super.dispose();
  }

  /// Updates the parallax offset based on current scroll position
  /// 
  /// Calculates the offset by multiplying scroll position by parallax factor
  /// to create the effect of background moving slower than foreground.
  /// 
  /// Only updates if parallax is enabled to avoid unnecessary rebuilds.
  void _updateParallaxOffset() {
    if (!widget.enableParallax) {
      // If parallax is disabled, don't update offset
      if (_parallaxOffset != 0.0) {
        setState(() {
          _parallaxOffset = 0.0;
        });
      }
      return;
    }

    // Calculate new parallax offset
    // Positive scroll position (scrolling down) creates negative offset (moves up slower)
    final scrollPosition = widget.scrollController.position.pixels;
    final newOffset = scrollPosition * widget.parallaxFactor;

    // Only update state if offset actually changed to avoid unnecessary rebuilds
    if ((_parallaxOffset - newOffset).abs() > 0.1) {
      setState(() {
        _parallaxOffset = newOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // Background layer with parallax transform
          Positioned.fill(
            child: Transform.translate(
              // Apply parallax offset - background moves slower than scroll
              // Negative offset because we want to move up when scrolling down
              offset: Offset(0, -_parallaxOffset),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.gradientColors,
                  ),
                ),
              ),
            ),
          ),
          // Foreground content (moves at normal scroll speed)
          widget.child,
        ],
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _ParallaxBackgroundState &&
        other._parallaxOffset == _parallaxOffset;
  }

  @override
  int get hashCode => _parallaxOffset.hashCode;
}
