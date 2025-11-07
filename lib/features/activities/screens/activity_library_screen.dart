import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/dimensions.dart';
import '../../../core/constants/typography.dart';
import '../../../core/widgets/activity_card.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/enums.dart';
import '../providers/activity_provider.dart';
import '../providers/wellness_pillar_provider.dart';

/// ActivityLibraryScreen displays all available activities with search and filter functionality
class ActivityLibraryScreen extends StatefulWidget {
  const ActivityLibraryScreen({super.key});

  @override
  State<ActivityLibraryScreen> createState() => _ActivityLibraryScreenState();
}

class _ActivityLibraryScreenState extends State<ActivityLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedPillarFilter;

  @override
  void initState() {
    super.initState();
    // Load activities and pillars if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityProvider = context.read<ActivityProvider>();
      final pillarProvider = context.read<WellnessPillarProvider>();
      
      if (activityProvider.activities.isEmpty) {
        activityProvider.loadActivities();
      }
      
      if (pillarProvider.pillars.isEmpty) {
        pillarProvider.loadPillars();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildSearchAndFilter(context),
          Expanded(
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Activity Library',
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

  Widget _buildSearchAndFilter(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search activities…',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.mediumGray,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.mediumGray,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.neutralGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing16,
                vertical: AppDimensions.spacing12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: AppDimensions.spacing12),
          // Filter dropdown
          _buildFilterDropdown(context),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(BuildContext context) {
    return Consumer<WellnessPillarProvider>(
      builder: (context, pillarProvider, child) {
        final pillars = pillarProvider.pillars;
        
        return Container(
          decoration: BoxDecoration(
            color: AppColors.neutralGray,
            borderRadius: BorderRadius.circular(AppDimensions.buttonBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing4,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: _selectedPillarFilter,
              isExpanded: true,
              hint: Text(
                'Filter by wellness pillar',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.mediumGray,
                ),
              ),
              icon: const Icon(Icons.filter_list, color: AppColors.mediumGray),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    'All Pillars',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                ),
                ...pillars.map((pillar) {
                  return DropdownMenuItem<String?>(
                    value: pillar.id,
                    child: Text(
                      pillar.name,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedPillarFilter = value;
                });
              },
            ),
          ),
        );
      },
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

        // Get filtered activities
        final filteredActivities = _getFilteredActivities(activityProvider);

        if (filteredActivities.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildActivityGrid(context, filteredActivities);
      },
    );
  }

  List<Activity> _getFilteredActivities(ActivityProvider activityProvider) {
    var activities = activityProvider.activities;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      activities = activityProvider.searchActivities(_searchQuery);
    }

    // Apply pillar filter
    if (_selectedPillarFilter != null) {
      activities = activities
          .where((activity) => activity.pillarId == _selectedPillarFilter)
          .toList();
    }

    return activities;
  }

  Widget _buildActivityGrid(BuildContext context, List<Activity> activities) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= AppDimensions.breakpointTablet;
    final crossAxisCount = isTablet ? 3 : 2;
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.screenPaddingHorizontal),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        childAspectRatio: 0.78,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ActivityCard(
          name: activity.name,
          durationMinutes: activity.durationMinutes,
          difficulty: _convertDifficulty(activity.difficulty),
          location: activity.location,
          thumbnailUrl: activity.thumbnailUrl,
          onTap: () => _onActivityTap(context, activity.id),
          isGridView: true,
        );
      },
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
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'No activities available',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.mediumGray,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _selectedPillarFilter != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                    _selectedPillarFilter = null;
                  });
                },
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
                child: const Text('Clear Filters'),
              ),
            ],
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
              onPressed: () {
                context.read<ActivityProvider>().refresh();
              },
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
              child: const Text('Retry'),
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
