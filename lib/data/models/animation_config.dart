/// Animation configuration model for controlling animation behavior
/// across the application, with support for reduced motion accessibility
class AnimationConfig {
  /// Duration for fade-in animations
  final Duration fadeInDuration;
  
  /// Duration for slide-up animations
  final Duration slideUpDuration;
  
  /// Duration for carousel transition animations
  final Duration carouselTransitionDuration;
  
  /// Duration for hover transition animations
  final Duration hoverTransitionDuration;
  
  /// Delay between staggered animations in milliseconds
  final int staggerDelay;
  
  /// Whether parallax effects are enabled
  final bool enableParallax;
  
  /// Whether hover effects are enabled
  final bool enableHoverEffects;
  
  /// Maximum number of concurrent animations allowed
  final int maxConcurrentAnimations;

  const AnimationConfig({
    this.fadeInDuration = const Duration(milliseconds: 400),
    this.slideUpDuration = const Duration(milliseconds: 300),
    this.carouselTransitionDuration = const Duration(milliseconds: 400),
    this.hoverTransitionDuration = const Duration(milliseconds: 200),
    this.staggerDelay = 100,
    this.enableParallax = true,
    this.enableHoverEffects = true,
    this.maxConcurrentAnimations = 3,
  });

  /// Factory constructor for reduced animation mode
  /// Used for accessibility (reduced motion) or low-performance devices
  /// Requirement 16.3: Use instant transitions instead of animations
  factory AnimationConfig.reduced() {
    return const AnimationConfig(
      fadeInDuration: Duration.zero,
      slideUpDuration: Duration.zero,
      carouselTransitionDuration: Duration(milliseconds: 100),
      hoverTransitionDuration: Duration(milliseconds: 50),
      staggerDelay: 0,
      enableParallax: false,
      enableHoverEffects: true,
      maxConcurrentAnimations: 1,
    );
  }

  /// Create a copy of this config with optional parameter overrides
  AnimationConfig copyWith({
    Duration? fadeInDuration,
    Duration? slideUpDuration,
    Duration? carouselTransitionDuration,
    Duration? hoverTransitionDuration,
    int? staggerDelay,
    bool? enableParallax,
    bool? enableHoverEffects,
    int? maxConcurrentAnimations,
  }) {
    return AnimationConfig(
      fadeInDuration: fadeInDuration ?? this.fadeInDuration,
      slideUpDuration: slideUpDuration ?? this.slideUpDuration,
      carouselTransitionDuration: carouselTransitionDuration ?? this.carouselTransitionDuration,
      hoverTransitionDuration: hoverTransitionDuration ?? this.hoverTransitionDuration,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      enableParallax: enableParallax ?? this.enableParallax,
      enableHoverEffects: enableHoverEffects ?? this.enableHoverEffects,
      maxConcurrentAnimations: maxConcurrentAnimations ?? this.maxConcurrentAnimations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimationConfig &&
        other.fadeInDuration == fadeInDuration &&
        other.slideUpDuration == slideUpDuration &&
        other.carouselTransitionDuration == carouselTransitionDuration &&
        other.hoverTransitionDuration == hoverTransitionDuration &&
        other.staggerDelay == staggerDelay &&
        other.enableParallax == enableParallax &&
        other.enableHoverEffects == enableHoverEffects &&
        other.maxConcurrentAnimations == maxConcurrentAnimations;
  }

  @override
  int get hashCode {
    return Object.hash(
      fadeInDuration,
      slideUpDuration,
      carouselTransitionDuration,
      hoverTransitionDuration,
      staggerDelay,
      enableParallax,
      enableHoverEffects,
      maxConcurrentAnimations,
    );
  }

  @override
  String toString() {
    return 'AnimationConfig('
        'fadeInDuration: $fadeInDuration, '
        'slideUpDuration: $slideUpDuration, '
        'carouselTransitionDuration: $carouselTransitionDuration, '
        'hoverTransitionDuration: $hoverTransitionDuration, '
        'staggerDelay: $staggerDelay, '
        'enableParallax: $enableParallax, '
        'enableHoverEffects: $enableHoverEffects, '
        'maxConcurrentAnimations: $maxConcurrentAnimations'
        ')';
  }
}
