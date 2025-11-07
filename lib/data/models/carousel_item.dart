import 'package:flutter/material.dart';

/// CarouselItem represents a single item in the featured content carousel.
/// 
/// Each item contains:
/// - title: The main heading for the carousel item
/// - description: Supporting text describing the item
/// - imageUrl: Optional image URL for visual content
/// - onTap: Optional callback when the item is tapped
/// 
/// Requirements: 6.1, 6.2
class CarouselItem {
  /// The main heading for the carousel item
  final String title;
  
  /// Supporting text describing the item
  final String description;
  
  /// Optional image URL for visual content
  final String? imageUrl;
  
  /// Optional callback when the item is tapped
  final VoidCallback? onTap;
  
  /// Background gradient colors for the carousel item
  /// Defaults to a blue-green gradient if not specified
  final List<Color>? gradientColors;

  const CarouselItem({
    required this.title,
    required this.description,
    this.imageUrl,
    this.onTap,
    this.gradientColors,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CarouselItem &&
        other.title == title &&
        other.description == description &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      description,
      imageUrl,
    );
  }
}
