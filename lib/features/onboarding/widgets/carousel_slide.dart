import 'package:flutter/material.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';
import 'package:corpfinity_employee_app/core/constants/typography.dart';
import 'package:corpfinity_employee_app/core/constants/dimensions.dart';

/// CarouselSlide widget displays a single slide in the welcome carousel
/// with an illustration, header, and body text.
class CarouselSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool isActive;

  const CarouselSlide({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = AppColors.calmBlue,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder (using icon for now)
          AnimatedScale(
            scale: isActive ? 1.0 : 0.96,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.85,
              duration: const Duration(milliseconds: 300),
              child: _buildIllustration(),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing48),
          // Header text
          AnimatedSlide(
            offset: isActive ? Offset.zero : const Offset(0, 0.05),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Text(
              title,
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          // Body text
          AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.9,
            duration: const Duration(milliseconds: 300),
            child: Text(
              description,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            iconColor.withOpacity(0.25),
            iconColor.withOpacity(0.05),
          ],
          radius: 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.25),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: 110,
          color: AppColors.white,
        ),
      ),
    );
  }
}
