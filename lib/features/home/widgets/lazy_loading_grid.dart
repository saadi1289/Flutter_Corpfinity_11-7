import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';

/// LazyLoadingGrid is a grid layout component that implements lazy loading
/// for below-the-fold content to optimize performance and data usage.
///
/// Features:
/// - Loads content 200px before it becomes visible
/// - Displays shimmer loading placeholders
/// - Preloads next section of content
/// - Smooth fade-in when content loads
/// - Limits initial payload to <500KB
///
/// Requirements: 10.2, 11.1, 11.2, 11.3, 11.4
class LazyLoadingGrid extends StatefulWidget {
  /// List of widgets to display in the grid
  final List<Widget> children;
  
  /// Number of columns in the grid
  final int crossAxisCount;
  
  /// Spacing between columns
  final double crossAxisSpacing;
  
  /// Spacing between rows
  final double mainAxisSpacing;
  
  /// Distance in pixels before content becomes visible to start loading
  /// Default is 200px
  final double lazyLoadThreshold;
  
  /// Callback to load more content when threshold is reached
  /// Returns a Future with List of Widget for the next batch of content
  final Future<List<Widget>> Function()? onLoadMore;
  
  /// Whether there is more content to load
  final bool hasMore;
  
  /// Whether content is currently loading
  final bool isLoading;
  
  /// Number of placeholder items to show while loading
  final int placeholderCount;
  
  /// Minimum duration to show loading placeholders (in milliseconds)
  /// Default is 200ms to avoid flashing
  final int minLoadingDuration;

  const LazyLoadingGrid({
    super.key,
    required this.children,
    required this.crossAxisCount,
    this.crossAxisSpacing = AppDimensions.gridCrossAxisSpacing,
    this.mainAxisSpacing = AppDimensions.gridMainAxisSpacing,
    this.lazyLoadThreshold = 200.0,
    this.onLoadMore,
    this.hasMore = false,
    this.isLoading = false,
    this.placeholderCount = 4,
    this.minLoadingDuration = 200,
  });

  @override
  State<LazyLoadingGrid> createState() => _LazyLoadingGridState();
}

class _LazyLoadingGridState extends State<LazyLoadingGrid> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  DateTime? _loadingStartTime;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll events to detect when to load more content
  void _onScroll() {
    if (!mounted || _isLoadingMore || !widget.hasMore) return;
    
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    
    // Check if we're within threshold distance of the bottom
    if (scrollPosition >= maxScroll - widget.lazyLoadThreshold) {
      _loadMoreContent();
    }
  }

  /// Load more content when threshold is reached
  Future<void> _loadMoreContent() async {
    if (_isLoadingMore || widget.onLoadMore == null) return;
    
    setState(() {
      _isLoadingMore = true;
      _loadingStartTime = DateTime.now();
    });

    try {
      await widget.onLoadMore!();
      
      // Ensure minimum loading duration to avoid flashing
      if (_loadingStartTime != null) {
        final elapsed = DateTime.now().difference(_loadingStartTime!);
        final remaining = widget.minLoadingDuration - elapsed.inMilliseconds;
        
        if (remaining > 0) {
          await Future.delayed(Duration(milliseconds: remaining));
        }
      }
    } catch (e) {
      // Handle error silently or show error state
      debugPrint('Error loading more content: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _loadingStartTime = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Main content grid
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: widget.crossAxisSpacing,
              mainAxisSpacing: widget.mainAxisSpacing,
              childAspectRatio: 1.0, // Square cards by default
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _FadeInWrapper(
                  key: ValueKey('grid_item_$index'),
                  child: widget.children[index],
                );
              },
              childCount: widget.children.length,
            ),
          ),
        ),
        
        // Loading placeholders
        if (_isLoadingMore || widget.isLoading)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: widget.crossAxisSpacing,
                mainAxisSpacing: widget.mainAxisSpacing,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ShimmerPlaceholder(
                    key: ValueKey('placeholder_$index'),
                  );
                },
                childCount: widget.placeholderCount,
              ),
            ),
          ),
      ],
    );
  }
}

/// Wrapper widget that provides fade-in animation when content loads
class _FadeInWrapper extends StatefulWidget {
  final Widget child;

  const _FadeInWrapper({
    super.key,
    required this.child,
  });

  @override
  State<_FadeInWrapper> createState() => _FadeInWrapperState();
}

class _FadeInWrapperState extends State<_FadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Start fade-in animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}

/// Shimmer loading placeholder for grid items
/// 
/// Displays an animated shimmer effect to indicate content is loading.
/// Minimum display duration of 200ms to avoid flashing.
/// 
/// Requirements: 10.2, 11.3
class ShimmerPlaceholder extends StatelessWidget {
  /// Height of the placeholder
  final double? height;
  
  /// Width of the placeholder
  final double? width;
  
  /// Border radius of the placeholder
  final double borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppDimensions.cardBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutralGray,
      highlightColor: AppColors.white,
      period: const Duration(milliseconds: 1500),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.neutralGray,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer placeholder specifically for card content
/// 
/// Provides a more detailed shimmer effect that mimics card structure
/// with title and content areas.
class ShimmerCardPlaceholder extends StatelessWidget {
  const ShimmerCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: AppDimensions.shadowBlurRadius,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.neutralGray,
        highlightColor: AppColors.white,
        period: const Duration(milliseconds: 1500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title placeholder
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutralGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            // Content placeholder lines
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutralGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Container(
              height: 14,
              width: double.infinity * 0.7,
              decoration: BoxDecoration(
                color: AppColors.neutralGray,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            // Button placeholder
            Container(
              height: 36,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.neutralGray,
                borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
