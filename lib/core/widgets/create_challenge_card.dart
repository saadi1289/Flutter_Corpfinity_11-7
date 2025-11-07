import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';

/// CreateChallengeCard is a prominent card widget that provides an entry point
/// to the challenge creation flow from the home screen.
/// 
/// Features:
/// - Height: 120px
/// - Background: warmOrange with 10% opacity
/// - Border: 2px solid warmOrange
/// - Full-width button with warmOrange background and white text
/// 
/// Requirements: 5.1, 5.2, 5.3, 5.4, 5.5
class CreateChallengeCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? semanticLabel;

  const CreateChallengeCard({
    super.key,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Create a new wellness challenge',
      button: true,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.warmOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
          border: Border.all(
            color: AppColors.warmOrange,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.cardPadding),
        child: Center(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warmOrange,
                foregroundColor: AppColors.white,
                elevation: 2,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                  vertical: AppDimensions.spacing12,
                ),
                minimumSize: const Size(double.infinity, AppDimensions.minTouchTarget),
              ),
              child: const Text(
                'Create Challenge',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
