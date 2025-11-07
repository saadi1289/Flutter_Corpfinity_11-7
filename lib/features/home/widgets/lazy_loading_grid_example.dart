import 'package:flutter/material.dart';
import 'lazy_loading_grid.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';

/// Example usage of LazyLoadingGrid component
/// 
/// This example demonstrates:
/// - Basic grid setup with lazy loading
/// - Loading more content when scrolling near bottom
/// - Shimmer placeholders during loading
/// - Responsive grid columns based on screen width
class LazyLoadingGridExample extends StatefulWidget {
  const LazyLoadingGridExample({super.key});

  @override
  State<LazyLoadingGridExample> createState() => _LazyLoadingGridExampleState();
}

class _LazyLoadingGridExampleState extends State<LazyLoadingGridExample> {
  List<Widget> _items = [];
  bool _hasMore = true;
  bool _isLoading = false;
  int _currentPage = 0;
  static const int _itemsPerPage = 8;

  @override
  void initState() {
    super.initState();
    _loadInitialContent();
  }

  /// Load initial content
  void _loadInitialContent() {
    setState(() {
      _items = _generateItems(0, _itemsPerPage);
      _currentPage = 1;
    });
  }

  /// Load more content when scrolling near bottom
  Future<List<Widget>> _loadMoreContent() async {
    if (_isLoading) return [];

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final newItems = _generateItems(
      _currentPage * _itemsPerPage,
      _itemsPerPage,
    );

    setState(() {
      _items.addAll(newItems);
      _currentPage++;
      _isLoading = false;
      
      // Stop loading after 5 pages for demo
      if (_currentPage >= 5) {
        _hasMore = false;
      }
    });

    return newItems;
  }

  /// Generate sample grid items
  List<Widget> _generateItems(int startIndex, int count) {
    return List.generate(count, (index) {
      final itemIndex = startIndex + index;
      return _SampleGridItem(
        title: 'Item ${itemIndex + 1}',
        subtitle: 'Description for item ${itemIndex + 1}',
        color: _getColorForIndex(itemIndex),
      );
    });
  }

  /// Get color based on index for visual variety
  Color _getColorForIndex(int index) {
    final colors = [
      AppColors.calmBlue,
      AppColors.softGreen,
      AppColors.warmOrange,
      AppColors.gentleRed,
      AppColors.softPurple,
      AppColors.freshGreen,
    ];
    return colors[index % colors.length];
  }

  /// Determine grid columns based on screen width
  int _getGridColumns(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return 1; // Mobile: single column
    } else if (width < 1200) {
      return 2; // Tablet: two columns
    } else {
      return 3; // Desktop: three columns
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lazy Loading Grid Example'),
        backgroundColor: AppColors.calmBlue,
        foregroundColor: AppColors.white,
      ),
      body: LazyLoadingGrid(
        crossAxisCount: _getGridColumns(context),
        onLoadMore: _loadMoreContent,
        hasMore: _hasMore,
        isLoading: _isLoading,
        placeholderCount: 4,
        children: _items,
      ),
    );
  }
}

/// Sample grid item widget
class _SampleGridItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _SampleGridItem({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color header
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.cardBorderRadius),
                topRight: Radius.circular(AppDimensions.cardBorderRadius),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.star,
                size: 40,
                color: AppColors.white,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headingMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
