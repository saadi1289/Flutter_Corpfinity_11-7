import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../constants/dimensions.dart';

/// Data model for navigation items
/// 
/// Represents a single navigation item with icon, label, and route
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

/// AnimatedBottomNavigation provides a fixed bottom navigation bar
/// with smooth animations and visual feedback
/// 
/// Features:
/// - Fixed positioning during scroll
/// - Active item highlighting with color change
/// - Icon scale animation on selection
/// - Immediate tap feedback (<100ms)
/// - Maximum 4 navigation items
/// - Shadow elevation for depth perception
/// 
/// Requirements: 13.1, 13.2, 13.3, 13.5, 15.1
class AnimatedBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationItem> items;

  const AnimatedBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : assert(items.length <= 4, 'Maximum 4 navigation items allowed');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _AnimatedNavBarItem(
                key: ValueKey('nav_${items[index].label.toLowerCase()}'),
                icon: items[index].icon,
                label: items[index].label,
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Internal animated navigation bar item widget
/// 
/// Provides smooth animations and visual feedback for navigation items
class _AnimatedNavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedNavBarItem> createState() => _AnimatedNavBarItemState();
}

class _AnimatedNavBarItemState extends State<_AnimatedNavBarItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive ? AppColors.calmBlue : AppColors.mediumGray;
    
    // Scale animation for active state using TweenAnimationBuilder
    // Requirement 13.2: Icon scale animation on selection
    // Requirement 16.2: Add semantic labels for screen readers
    return Semantics(
      button: true,
      label: widget.label,
      hint: widget.isActive ? 'Currently selected' : 'Tap to navigate to ${widget.label}',
      selected: widget.isActive,
      enabled: true,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween<double>(
          begin: 1.0,
          end: widget.isActive ? 1.0 : 1.0,
        ),
        builder: (context, scale, child) {
          return ExcludeSemantics(
            child: GestureDetector(
              onTapDown: (_) {
                // Requirement 13.3: Immediate tap feedback (<100ms)
                setState(() => _isPressed = true);
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                widget.onTap();
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing12,
                  vertical: AppDimensions.spacing8,
                ),
                decoration: BoxDecoration(
                  color: _isPressed 
                      ? AppColors.neutralGray.withValues(alpha: 0.5)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: SizedBox(
                  // Requirement 13.5, 16.1: Navigation items 48x48 points
                  width: AppDimensions.navItemTouchTarget,
                  height: AppDimensions.navItemTouchTarget,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with scale animation
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween<double>(
                          begin: 1.0,
                          end: widget.isActive ? 1.1 : 1.0,
                        ),
                        builder: (context, iconScale, child) {
                          return Transform.scale(
                            scale: iconScale,
                            child: Icon(
                              widget.icon,
                              color: color,
                              size: AppDimensions.iconSizeMedium,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.spacing4),
                      // Label with color transition
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: AppTypography.captionBold.copyWith(
                          color: color,
                        ),
                        child: Text(
                          widget.label,
                          style: AppTypography.captionBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
