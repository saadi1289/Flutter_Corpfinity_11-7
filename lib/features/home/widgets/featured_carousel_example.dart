import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/carousel_item.dart';
import 'featured_carousel.dart';

/// Example usage of FeaturedCarousel widget
/// This demonstrates how to integrate the carousel into the HomeScreen
class FeaturedCarouselExample extends StatelessWidget {
  const FeaturedCarouselExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Example carousel items with different gradient colors
    final carouselItems = [
      CarouselItem(
        title: 'Mindful Meditation',
        description: 'Start your day with a 10-minute guided meditation',
        gradientColors: const [AppColors.calmBlue, AppColors.softGreen],
        onTap: () {
          // Navigate to meditation activity
          debugPrint('Navigate to meditation');
        },
      ),
      CarouselItem(
        title: 'Team Yoga Session',
        description: 'Join our weekly yoga class every Wednesday at 5 PM',
        gradientColors: const [AppColors.softGreen, AppColors.warmOrange],
        onTap: () {
          // Navigate to yoga session
          debugPrint('Navigate to yoga');
        },
      ),
      CarouselItem(
        title: 'Wellness Challenge',
        description: 'Complete 30 days of daily activities and win rewards',
        gradientColors: const [AppColors.warmOrange, AppColors.gentleRed],
        onTap: () {
          // Navigate to wellness challenge
          debugPrint('Navigate to challenge');
        },
      ),
      CarouselItem(
        title: 'Stress Relief Workshop',
        description: 'Learn techniques to manage workplace stress effectively',
        gradientColors: const [AppColors.calmBlue, AppColors.softPurple],
        onTap: () {
          // Navigate to workshop
          debugPrint('Navigate to workshop');
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Carousel Example'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Featured Activities',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Featured Carousel
              FeaturedCarousel(
                items: carouselItems,
                height: 220.0,
                autoAdvanceDuration: const Duration(seconds: 5),
                transitionDuration: const Duration(milliseconds: 400),
                onItemChanged: (index) {
                  debugPrint('Carousel changed to index: $index');
                },
              ),
              
              const SizedBox(height: 24),
              
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Other Content',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              // Placeholder for other content
              Container(
                height: 200,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.neutralGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Other content goes here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
