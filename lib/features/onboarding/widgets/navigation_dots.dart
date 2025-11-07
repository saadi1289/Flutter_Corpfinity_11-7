import 'package:flutter/material.dart';
import 'package:corpfinity_employee_app/core/constants/colors.dart';
import 'package:corpfinity_employee_app/core/constants/dimensions.dart';

/// NavigationDots displays page indicators for the carousel
/// with active and inactive states.
class NavigationDots extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final Color activeColor;
  final Color inactiveColor;

  const NavigationDots({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    this.activeColor = AppColors.calmBlue,
    this.inactiveColor = AppColors.neutralGray,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing4,
          ),
          width: index == currentIndex ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.spacing4),
            color: index == currentIndex ? null : inactiveColor,
            gradient: index == currentIndex
                ? const LinearGradient(
                    colors: [AppColors.white, AppColors.white],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            boxShadow: index == currentIndex
                ? [
                    BoxShadow(
                      color: AppColors.white.withOpacity(0.25),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
