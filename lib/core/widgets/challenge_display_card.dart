import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';

/// ChallengeDisplayCard displays a generated wellness challenge in a card.
/// 
/// Features:
/// - Minimum height of 150px
/// - Light gray background with calm blue border
/// - 24px padding for comfortable reading
/// - Centered bodyLarge text style
/// - Fade-in animation (400ms) on display
/// 
/// Used in the challenge creation flow to display the generated challenge.
class ChallengeDisplayCard extends StatefulWidget {
  final String challengeText;

  const ChallengeDisplayCard({
    super.key,
    required this.challengeText,
  });

  @override
  State<ChallengeDisplayCard> createState() => _ChallengeDisplayCardState();
}

class _ChallengeDisplayCardState extends State<ChallengeDisplayCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Start the fade-in animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Generated challenge: ${widget.challengeText}',
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          constraints: const BoxConstraints(minHeight: 150),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.cardBorderRadius),
            border: Border.all(color: AppColors.calmBlue, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_rounded, color: AppColors.calmBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Challenge Ready',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.calmBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing16),
              // Body
              Text(
                widget.challengeText,
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
