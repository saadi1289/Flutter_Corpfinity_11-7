# LazyLoadingGrid Component

## Overview

The `LazyLoadingGrid` component is a high-performance grid layout that implements lazy loading for below-the-fold content. It optimizes performance and data usage by loading content only when needed, displays shimmer loading placeholders, and provides smooth fade-in animations.

## Features

- ✅ **Lazy Loading**: Loads content 200px before it becomes visible
- ✅ **Shimmer Placeholders**: Displays animated loading indicators
- ✅ **Preloading**: Preloads next section of content for seamless scrolling
- ✅ **Smooth Animations**: Fade-in effect when content loads
- ✅ **Performance Optimized**: Limits initial payload to <500KB
- ✅ **Responsive**: Adapts to different screen sizes and grid columns
- ✅ **Minimum Loading Duration**: Prevents flashing by enforcing 200ms minimum display time

## Requirements Addressed

- **10.2**: Display shimmer loading placeholders for content that is loading
- **11.1**: Implement lazy loading for content more than 200px below visible viewport
- **11.2**: Begin loading content when user scrolls within 100px of below-the-fold content
- **11.3**: Display loading indicators with minimum 200ms duration
- **11.4**: Preload next section of content before it becomes visible

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'lazy_loading_grid.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  List<Widget> _items = [];
  bool _hasMore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialContent();
  }

  void _loadInitialContent() {
    setState(() {
      _items = _generateItems(0, 8);
    });
  }

  Future<List<Widget>> _loadMoreContent() async {
    setState(() => _isLoading = true);
    
    // Fetch more content from API
    final newItems = await fetchMoreItems();
    
    setState(() {
      _items.addAll(newItems);
      _isLoading = false;
      _hasMore = newItems.isNotEmpty;
    });
    
    return newItems;
  }

  @override
  Widget build(BuildContext context) {
    return LazyLoadingGrid(
      children: _items,
      crossAxisCount: 2,
      onLoadMore: _loadMoreContent,
      hasMore: _hasMore,
      isLoading: _isLoading,
    );
  }
}
```

### Responsive Grid Columns

```dart
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

LazyLoadingGrid(
  children: _items,
  crossAxisCount: _getGridColumns(context),
  // ... other properties
)
```

### Custom Spacing

```dart
LazyLoadingGrid(
  children: _items,
  crossAxisCount: 2,
  crossAxisSpacing: 20.0,
  mainAxisSpacing: 20.0,
  // ... other properties
)
```

### Custom Loading Threshold

```dart
LazyLoadingGrid(
  children: _items,
  crossAxisCount: 2,
  lazyLoadThreshold: 300.0, // Load 300px before visible
  // ... other properties
)
```

## Component Properties

### LazyLoadingGrid

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `children` | `List<Widget>` | Required | List of widgets to display in the grid |
| `crossAxisCount` | `int` | Required | Number of columns in the grid |
| `crossAxisSpacing` | `double` | 16.0 | Spacing between columns |
| `mainAxisSpacing` | `double` | 16.0 | Spacing between rows |
| `lazyLoadThreshold` | `double` | 200.0 | Distance in pixels before content becomes visible to start loading |
| `onLoadMore` | `Future<List<Widget>> Function()?` | null | Callback to load more content |
| `hasMore` | `bool` | false | Whether there is more content to load |
| `isLoading` | `bool` | false | Whether content is currently loading |
| `placeholderCount` | `int` | 4 | Number of placeholder items to show while loading |
| `minLoadingDuration` | `int` | 200 | Minimum duration (ms) to show loading placeholders |

## Shimmer Placeholders

The component includes two types of shimmer placeholders:

### ShimmerPlaceholder

Basic shimmer placeholder for simple loading states.

```dart
ShimmerPlaceholder(
  height: 120,
  width: double.infinity,
  borderRadius: 16.0,
)
```

### ShimmerCardPlaceholder

Detailed shimmer placeholder that mimics card structure with title and content areas.

```dart
ShimmerCardPlaceholder()
```

## Performance Considerations

1. **Lazy Loading**: Content is only loaded when user scrolls near it (200px threshold)
2. **Minimum Loading Duration**: 200ms minimum prevents flashing for fast loads
3. **Fade-in Animation**: Smooth 300ms fade-in when content appears
4. **Scroll Optimization**: Scroll listener is optimized to avoid excessive rebuilds
5. **Memory Management**: Proper disposal of scroll controllers and animation controllers

## Integration with HomeScreen

The LazyLoadingGrid is designed to replace the current CustomScrollView slivers in the HomeScreen:

```dart
// Before (in HomeScreen)
CustomScrollView(
  slivers: [
    SliverGrid(
      delegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      // ...
    ),
  ],
)

// After (using LazyLoadingGrid)
LazyLoadingGrid(
  children: contentCards,
  crossAxisCount: _getGridColumns(context),
  onLoadMore: _loadMoreContent,
  hasMore: _hasMoreContent,
  isLoading: _isLoadingMore,
)
```

## Testing

See `lazy_loading_grid_example.dart` for a complete working example that demonstrates:
- Initial content loading
- Lazy loading on scroll
- Shimmer placeholders
- Responsive grid columns
- Pagination logic

## Related Components

- `AnimatedContentCard`: Wrap grid items for entrance animations and hover effects
- `ShimmerPlaceholder`: Standalone shimmer loading indicator
- `ResponsiveLayoutManager`: Utility for determining grid columns based on screen size

## Notes

- The component uses `CustomScrollView` with `SliverGrid` for optimal performance
- Scroll controller is automatically managed and disposed
- Loading state is tracked internally to prevent duplicate load requests
- The component enforces a minimum 200ms loading duration to avoid flashing
- Fade-in animations are applied to all loaded content for smooth appearance
