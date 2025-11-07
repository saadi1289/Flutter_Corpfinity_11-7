import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/typography.dart';

/// ElegantGenerateButton is a premium button widget with gradient background,
/// multi-layered shadows, and smooth animations for the challenge generation flow.
/// 
/// Features:
/// - Gradient background from calmBlue to softGreen
/// - Multi-layered shadow effects
/// - Scale animation on press (1.0 to 0.98)
/// - Ripple effect with white color at 20% opacity
/// - Loading state with CircularProgressIndicator
/// - Disabled state with reduced opacity
/// - Minimum 44x44px touch target for accessibility
class ElegantGenerateButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;
  final bool isLoading;

  const ElegantGenerateButton({
    super.key,
    required this.onPressed,
    this.label = 'Generate Challenge',
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  State<ElegantGenerateButton> createState() => _ElegantGenerateButtonState();
}

class _ElegantGenerateButtonState extends State<ElegantGenerateButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isInteractive) {
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isInteractive) {
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isInteractive) {
      _scaleController.reverse();
    }
  }

  bool get _isInteractive => widget.isEnabled && !widget.isLoading && widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Generate wellness challenge',
      button: true,
      enabled: _isInteractive,
      child: Opacity(
        opacity: _isInteractive ? 1.0 : 0.5,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isInteractive ? widget.onPressed : null,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Container(
                  height: AppDimensions.buttonHeightLarge,
                  constraints: const BoxConstraints(
                    minHeight: AppDimensions.minTouchTarget,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.calmBlue, AppColors.softGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    boxShadow: [
                      // Primary shadow with calmBlue
                      BoxShadow(
                        color: AppColors.calmBlue.withOpacity(0.25),
                        blurRadius: 20.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 8),
                      ),
                      // Secondary shadow with black
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: widget.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white,
                              ),
                            ),
                          )
                        : Text(
                            widget.label,
                            style: AppTypography.buttonLarge,
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
