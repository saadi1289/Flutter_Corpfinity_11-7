import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../providers/wellness_pillar_provider.dart';
import '../widgets/wellness_pillar_card.dart';

/// WellnessPillarScreen displays a 2-column grid of 6 wellness pillars
/// for the user to select based on their energy level
class WellnessPillarScreen extends StatefulWidget {
  final String? energyLevel;

  const WellnessPillarScreen({
    super.key,
    this.energyLevel,
  });

  @override
  State<WellnessPillarScreen> createState() => _WellnessPillarScreenState();
}

class _WellnessPillarScreenState extends State<WellnessPillarScreen> {
  @override
  void initState() {
    super.initState();
    // Load wellness pillars when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WellnessPillarProvider>().loadPillars();
    });
  }

  void _handlePillarTap(BuildContext context, String pillarId) {
    final provider = context.read<WellnessPillarProvider>();
    provider.selectPillar(pillarId);
    
    // Navigate to activity selection screen with pillar and energy level
    context.push(
      '/activities?pillar=$pillarId&energy=${widget.energyLevel ?? "medium"}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Choose Your Focus',
          style: AppTypography.headingLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<WellnessPillarProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: AppDimensions.iconSizeXLarge,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Text(
                      'Failed to load wellness pillars',
                      style: AppTypography.bodyLarge,
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    Text(
                      provider.error!,
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing24),
                    ElevatedButton(
                      onPressed: () => provider.loadPillars(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final pillars = provider.pillars;

            if (pillars.isEmpty) {
              return Center(
                child: Text(
                  'No wellness pillars available',
                  style: AppTypography.bodyLarge,
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Header section with energy level info
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      AppDimensions.screenPaddingHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimensions.spacing8),
                        if (widget.energyLevel != null)
                          _buildEnergyLevelBadge(widget.energyLevel!),
                        const SizedBox(height: AppDimensions.spacing16),
                        Text(
                          'Select a wellness area to explore activities',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.mediumGray,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing24),
                      ],
                    ),
                  ),
                ),

                // 2-column grid of wellness pillar cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenPaddingHorizontal,
                  ),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final isTablet = width >= AppDimensions.breakpointTablet;
                      final crossAxisCount = isTablet ? 3 : 2;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
                          mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
                          childAspectRatio: 0.95,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final pillar = pillars[index];
                            return WellnessPillarCard(
                              pillar: pillar,
                              onTap: () => _handlePillarTap(context, pillar.id),
                            );
                          },
                          childCount: pillars.length,
                        ),
                      );
                    },
                  ),
                ),

                // Bottom spacing with SafeArea padding
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: AppDimensions.spacing32 + 
                            MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnergyLevelBadge(String energyLevel) {
    Color badgeColor;
    String displayText;

    switch (energyLevel.toLowerCase()) {
      case 'low':
        badgeColor = AppColors.energyLow;
        displayText = 'Low Energy';
        break;
      case 'high':
        badgeColor = AppColors.energyHigh;
        displayText = 'High Energy';
        break;
      case 'medium':
      default:
        badgeColor = AppColors.energyMedium;
        displayText = 'Medium Energy';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt_rounded,
            size: AppDimensions.iconSizeSmall,
            color: badgeColor,
          ),
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            displayText,
            style: AppTypography.labelSmall.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
