import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../data/models/enums.dart';
import '../providers/activity_provider.dart';
import '../providers/wellness_pillar_provider.dart';

/// ActivitySelectionScreen displays recommended activities based on energy level and pillar
class ActivitySelectionScreen extends StatefulWidget {
  final String? pillarId;
  final String? energyLevel;

  const ActivitySelectionScreen({
    super.key,
    this.pillarId,
    this.energyLevel,
  });

  @override
  State<ActivitySelectionScreen> createState() => _ActivitySelectionScreenState();
}

class _ActivitySelectionScreenState extends State<ActivitySelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Load activities if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityProvider = context.read<ActivityProvider>();
      if (activityProvider.activities.isEmpty) {
        activityProvider.loadActivities();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final pillarProvider = context.read<WellnessPillarProvider>();
    final pillar = widget.pillarId != null 
        ? pillarProvider.getPillarById(widget.pillarId!)
        : null;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
        onPressed: () => context.pop(),
      ),
      title: Text(
        pillar?.name ?? 'Select Activity',
        style: AppTypography.headingMedium.copyWith(color: AppColors.darkText),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.neutralGray,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<ActivityProvider>(
      builder: (context, activityProvider, child) {
        if (activityProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.calmBlue),
            ),
          );
        }

        if (activityProvider.error != null) {
          return _buildErrorState(context, activityProvider.error!);
        }

        // Parse energy level
        final energyLevel = _parseEnergyLevel(widget.energyLevel);
        if (energyLevel == null || widget.pillarId == null) {
          return _buildErrorState(context, 'Missing required parameters');
        }

        // Get recommended activities
        final activities = activityProvider.getRecommendedActivities(
          energyLevel: energyLevel,
          pillarId: widget.pillarId!,
        );

        if (activities.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildActivityList(context, activities);
      },
    );
  }

  Widget _buildActivityList(BuildContext context, List activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                'Recommended for you',
                style: AppTypography.headingSmall.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              Text(
                'Based on your ${_getEnergyLevelDisplay(widget.energyLevel)} energy level',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingHorizontal,
              vertical: AppDimensions.spacing8,
            ),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: AppDimensions.spacing16,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ActivityCard(
                name: activity.name,
                durationMinutes: activity.durationMinutes,
                difficulty: _convertDifficulty(activity.difficulty),
                location: activity.location,
                thumbnailUrl: activity.thumbnailUrl,
                onTap: () => _onActivityTap(context, activity.id),
                isGridView: false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: AppDimensions.iconSizeXLarge * 2,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'No activities found',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'Try selecting a different energy level or wellness pillar',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconSizeXLarge * 2,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'Something went wrong',
              style: AppTypography.headingMedium.copyWith(
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              error,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing24),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.calmBlue,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing24,
                  vertical: AppDimensions.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  void _onActivityTap(BuildContext context, String activityId) {
    // Select the activity in the provider
    context.read<ActivityProvider>().selectActivity(activityId);
    
    // Navigate to activity guide screen
    context.push('/activity/$activityId');
  }

  EnergyLevel? _parseEnergyLevel(String? energyLevelStr) {
    if (energyLevelStr == null) return null;
    
    switch (energyLevelStr.toLowerCase()) {
      case 'low':
        return EnergyLevel.low;
      case 'medium':
        return EnergyLevel.medium;
      case 'high':
        return EnergyLevel.high;
      default:
        return null;
    }
  }

  String _getEnergyLevelDisplay(String? energyLevelStr) {
    if (energyLevelStr == null) return '';
    
    switch (energyLevelStr.toLowerCase()) {
      case 'low':
        return 'low';
      case 'medium':
        return 'medium';
      case 'high':
        return 'high';
      default:
        return '';
    }
  }

  ActivityDifficulty _convertDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.low:
        return ActivityDifficulty.low;
      case Difficulty.medium:
        return ActivityDifficulty.medium;
      case Difficulty.high:
        return ActivityDifficulty.high;
    }
  }
}
