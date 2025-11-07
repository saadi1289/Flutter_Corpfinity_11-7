import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/utils/image_optimizer.dart';
import '../../../data/models/carousel_item.dart';

/// FeaturedCarousel displays a horizontally scrollable carousel of featured content
/// with auto-advance functionality, smooth animations, and pagination indicators.
/// 
/// Features:
/// - Horizontal PageView with momentum physics
/// - Auto-advance timer (5 seconds default)
/// - Smooth snap-to-position behavior
/// - Pagination indicators
/// - Swipe gesture support
/// - Lazy loading for images
/// 
/// Requirements: 6.1, 6.2, 6.3, 6.4, 6.5
class FeaturedCarousel extends StatefulWidget {
  /// List of carousel items to display
  final List<CarouselItem> items;
  
  /// Duration before auto-advancing to next item
  final Duration autoAdvanceDuration;
  
  /// Duration for transition animation
  final Duration transitionDuration;
  
  /// Callback when carousel page changes
  final ValueChanged<int>? onItemChanged;
  
  /// Height of the carousel
  final double height;

  const FeaturedCarousel({
    super.key,
    required this.items,
    this.autoAdvanceDuration = const Duration(seconds: 5),
    this.transitionDuration = const Duration(milliseconds: 400),
    this.onItemChanged,
    this.height = 200.0,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoAdvanceTimer;
  bool _userInteracting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.9, // Show slight preview of adjacent items
    );
    _startAutoAdvanceTimer();
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Start the auto-advance timer
  void _startAutoAdvanceTimer() {
    _autoAdvanceTimer?.cancel();
    
    // Only auto-advance if there are multiple items and user is not interacting
    if (widget.items.length > 1 && !_userInteracting) {
      _autoAdvanceTimer = Timer(widget.autoAdvanceDuration, () {
        if (mounted && !_userInteracting) {
          _advanceToNextPage();
        }
      });
    }
  }

  /// Advance to the next page with smooth animation
  void _advanceToNextPage() {
    if (!mounted) return;
    
    final nextPage = (_currentPage + 1) % widget.items.length;
    
    // Requirement 16.3: Use instant transitions for reduced motion
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    
    if (reducedMotion) {
      _pageController.jumpToPage(nextPage);
    } else {
      _pageController.animateToPage(
        nextPage,
        duration: widget.transitionDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  /// Handle page change
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    
    widget.onItemChanged?.call(page);
    
    // Restart auto-advance timer after page change
    _startAutoAdvanceTimer();
  }

  /// Handle user interaction start
  void _onUserInteractionStart() {
    setState(() {
      _userInteracting = true;
    });
    _autoAdvanceTimer?.cancel();
  }

  /// Handle user interaction end
  void _onUserInteractionEnd() {
    setState(() {
      _userInteracting = false;
    });
    // Reset timer after user interaction
    _startAutoAdvanceTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Requirement 16.2: Semantic labels for carousel
    return Semantics(
      label: 'Featured content carousel',
      hint: 'Swipe left or right to browse featured items. Currently showing item ${_currentPage + 1} of ${widget.items.length}',
      child: Column(
        children: [
          // Carousel PageView
          SizedBox(
            height: widget.height,
            child: GestureDetector(
            onPanDown: (_) => _onUserInteractionStart(),
            onPanEnd: (_) => _onUserInteractionEnd(),
            onPanCancel: () => _onUserInteractionEnd(),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.items.length,
              physics: const BouncingScrollPhysics(), // Momentum physics
              itemBuilder: (context, index) {
                return _CarouselItemWidget(
                  item: widget.items[index],
                  onTap: () {
                    _onUserInteractionStart();
                    widget.items[index].onTap?.call();
                    // Delay to allow tap animation to complete
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        _onUserInteractionEnd();
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
        
          const SizedBox(height: AppDimensions.spacing12),
          
          // Pagination Indicators
          _PaginationIndicators(
            itemCount: widget.items.length,
            currentIndex: _currentPage,
          ),
        ],
      ),
    );
  }
}

/// Individual carousel item widget with ripple effect and lazy loading
class _CarouselItemWidget extends StatelessWidget {
  final CarouselItem item;
  final VoidCallback? onTap;

  const _CarouselItemWidget({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Requirement 16.2: Semantic labels for carousel items
    return Semantics(
      button: true,
      label: '${item.title}. ${item.description}',
      hint: 'Tap to view details',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing8,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.gradientColors ?? [
                  AppColors.calmBlue,
                  AppColors.softGreen,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              child: Stack(
                children: [
                  // Background image (if provided)
                  if (item.imageUrl != null)
                    Positioned.fill(
                      child: Builder(
                        builder: (context) {
                          // Get optimal cache dimensions for carousel images
                          // Requirement 3.5, 10.1, 10.5: Optimize images to <200KB
                          final screenWidth = MediaQuery.of(context).size.width;
                          final cacheDimensions = ImageOptimizer.getCarouselImageCacheDimensions(
                            displayWidth: screenWidth * 0.9, // viewport fraction
                            displayHeight: 200.0, // carousel height
                            context: context,
                          );
                          
                          return CachedNetworkImage(
                            imageUrl: item.imageUrl!,
                            fit: BoxFit.cover,
                            memCacheWidth: cacheDimensions['width'],
                            memCacheHeight: cacheDimensions['height'],
                            maxWidthDiskCache: cacheDimensions['width'],
                            maxHeightDiskCache: cacheDimensions['height'],
                            placeholder: (context, url) => Container(
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black.withValues(alpha: 0.05),
                            ),
                          );
                        },
                      ),
                    ),
                  
                  // Gradient overlay for text readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  
                  // Content
                  Positioned(
                    left: AppDimensions.spacing20,
                    right: AppDimensions.spacing20,
                    bottom: AppDimensions.spacing20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Text(
                          item.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

/// Pagination indicators showing current position in carousel
class _PaginationIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _PaginationIndicators({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: index == currentIndex ? 24.0 : 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors.calmBlue
                : AppColors.neutralGray,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
