import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/typography.dart';
import '../widgets/responsive_scaffold.dart';
import '../widgets/responsive_grid.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/animated_progress_bar.dart';
import '../utils/responsive.dart';
import '../utils/color_contrast_validator.dart';
import '../utils/accessibility_tester.dart';

/// AccessibilityDemoScreen demonstrates responsive design and accessibility features.
/// This screen is for development and testing purposes only.
class AccessibilityDemoScreen extends StatelessWidget {
  const AccessibilityDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Accessibility Demo'),
      ),
      body: SingleChildScrollView(
        padding: responsive.getResponsivePadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScreenInfo(context, responsive),
            const SizedBox(height: 24),
            _buildButtonExamples(),
            const SizedBox(height: 24),
            _buildProgressExample(),
            const SizedBox(height: 24),
            _buildGridExample(),
            const SizedBox(height: 24),
            _buildContrastInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenInfo(BuildContext context, Responsive responsive) {
    final report = AccessibilityTester.generateReport(context);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Screen Information', style: AppTypography.headingLarge),
          const SizedBox(height: 12),
          _buildInfoRow('Width', '${responsive.width.toInt()}px'),
          _buildInfoRow('Height', '${responsive.height.toInt()}px'),
          _buildInfoRow('Text Scale', '${responsive.textScaleFactor.toStringAsFixed(2)}x'),
          _buildInfoRow('Device Type', _getDeviceType(responsive)),
          _buildInfoRow('Orientation', responsive.isPortrait ? 'Portrait' : 'Landscape'),
          _buildInfoRow('Screen Reader', report.accessibleNavigation ? 'Enabled' : 'Disabled'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(value, style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          )),
        ],
      ),
    );
  }

  String _getDeviceType(Responsive responsive) {
    if (responsive.isTablet) return 'Tablet';
    if (responsive.isSmallScreen) return 'Small Phone';
    if (responsive.isMediumScreen) return 'Medium Phone';
    return 'Large Phone';
  }

  Widget _buildButtonExamples() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Button Examples', style: AppTypography.headingLarge),
          const SizedBox(height: 12),
          Text(
            'All buttons meet 44x44 minimum touch target',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Primary Button',
            onPressed: () {},
            variant: ButtonVariant.primary,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Secondary Button',
            onPressed: () {},
            variant: ButtonVariant.secondary,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Small Button',
            onPressed: () {},
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressExample() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progress Bar Example', style: AppTypography.headingLarge),
          const SizedBox(height: 12),
          Text(
            'Progress announced to screen readers',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          AnimatedProgressBar(
            progress: 0.65,
            semanticLabel: 'Weekly goal progress',
          ),
          const SizedBox(height: 8),
          Text('65% Complete', style: AppTypography.caption),
        ],
      ),
    );
  }

  Widget _buildGridExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Responsive Grid', style: AppTypography.headingLarge),
        const SizedBox(height: 12),
        Text(
          'Grid adjusts columns based on screen size',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ResponsiveGrid(
            defaultColumns: 2,
            children: List.generate(
              4,
              (index) => CustomCard(
                child: Center(
                  child: Text('Item ${index + 1}'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContrastInfo() {
    final results = ColorContrastValidator.validateAppColors();
    final passedTests = results.values.where((v) => v).length;
    final totalTests = results.length;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color Contrast Validation', style: AppTypography.headingLarge),
          const SizedBox(height: 12),
          Text(
            'WCAG AA Standard: 4.5:1 minimum',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                passedTests == totalTests ? Icons.check_circle : Icons.warning,
                color: passedTests == totalTests ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                '$passedTests/$totalTests tests passed',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
