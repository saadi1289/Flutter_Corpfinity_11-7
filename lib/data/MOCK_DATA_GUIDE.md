# Mock Data Guide

This document describes the mock data available for development and testing of the Corpfinity Employee App.

## Overview

The `mock_data.dart` file contains comprehensive mock data for all major entities in the application:
- 6 Wellness Pillars
- 20 Activities (distributed across all pillars)
- Activity Steps with detailed instructions
- 10 Badges with unlock criteria
- Sample User data

## Wellness Pillars

### Available Pillars (6 total)

1. **Stress Reduction** (4 activities)
   - Focus: Calm your mind and reduce workplace stress
   - Icon: `assets/icons/stress_reduction.png`

2. **Increased Energy** (3 activities)
   - Focus: Boost your energy levels throughout the day
   - Icon: `assets/icons/increased_energy.png`

3. **Better Sleep** (3 activities)
   - Focus: Improve sleep quality and nighttime routines
   - Icon: `assets/icons/better_sleep.png`

4. **Physical Fitness** (4 activities)
   - Focus: Stay active with quick desk exercises
   - Icon: `assets/icons/physical_fitness.png`

5. **Healthy Eating** (3 activities)
   - Focus: Make better nutrition choices at work
   - Icon: `assets/icons/healthy_eating.png`

6. **Social Connection** (3 activities)
   - Focus: Build meaningful workplace relationships
   - Icon: `assets/icons/social_connection.png`

## Activities

### Activity Distribution by Pillar

- **Stress Reduction**: 4 activities (IDs: activity-001 to activity-004)
  - Deep Breathing Exercise (3 min, Low difficulty)
  - Progressive Muscle Relaxation (5 min, Low difficulty)
  - Desk Meditation (2 min, Low difficulty)
  - Gratitude Reflection (2 min, Low difficulty)

- **Increased Energy**: 3 activities (IDs: activity-005 to activity-007)
  - Desk Stretches (3 min, Low difficulty)
  - Power Pose (2 min, Low difficulty)
  - Hydration Break (1 min, Low difficulty)

- **Better Sleep**: 3 activities (IDs: activity-008 to activity-010)
  - Evening Wind-Down (4 min, Low difficulty)
  - Sleep Affirmations (2 min, Low difficulty)
  - Screen-Free Time (5 min, Medium difficulty)

- **Physical Fitness**: 4 activities (IDs: activity-011 to activity-014)
  - Desk Push-Ups (2 min, Medium difficulty)
  - Chair Squats (2 min, Medium difficulty)
  - Walking Break (5 min, Low difficulty)
  - Stair Climbing (3 min, High difficulty)

- **Healthy Eating**: 3 activities (IDs: activity-015 to activity-017)
  - Mindful Snacking (3 min, Low difficulty)
  - Hydration Check (1 min, Low difficulty)
  - Meal Planning Moment (3 min, Low difficulty)

- **Social Connection**: 3 activities (IDs: activity-018 to activity-020)
  - Coffee Chat (5 min, Low difficulty)
  - Gratitude Message (2 min, Low difficulty)
  - Team Check-In (3 min, Low difficulty)

### Activity Difficulty Levels

- **Low**: 15 activities (suitable for all energy levels)
- **Medium**: 4 activities (suitable for medium and high energy)
- **High**: 1 activity (suitable for high energy only)

### Activity Locations

- **At Desk**: 9 activities
- **Anywhere**: 8 activities
- **Private Space**: 1 activity
- **Hallway/Outside**: 1 activity
- **Stairwell**: 1 activity
- **Break Room**: 1 activity
- **Meeting Room**: 1 activity

## Activity Steps

Each activity includes 3-5 detailed steps with:
- Step number
- Title
- Instruction text
- Optional image URL
- Optional timer duration (in seconds)

Example step structure:
```dart
ActivityStep(
  stepNumber: 1,
  title: 'Get Comfortable',
  instruction: 'Sit upright in your chair...',
  imageUrl: 'assets/images/sitting_posture.jpg',
  timerSeconds: null, // Optional
)
```

## Badges

### Available Badges (10 total)

1. **First Step** - Complete your first activity
2. **3-Day Streak** - Complete activities for 3 consecutive days
3. **Week Warrior** - Complete activities for 7 consecutive days
4. **Stress Buster** - Complete 5 stress reduction activities
5. **Energy Booster** - Complete 5 energy-boosting activities
6. **Sleep Champion** - Complete 5 better sleep activities
7. **Fitness Fan** - Complete 10 physical fitness activities
8. **Wellness Explorer** - Complete at least one activity from each pillar
9. **Century Club** - Complete 100 total activities
10. **Social Butterfly** - Complete 5 social connection activities

All badges start as locked (`isUnlocked: false`) and can be unlocked based on user progress.

## Mock User

A sample user is provided with:
- **ID**: user-001
- **Email**: john.doe@corpfinity.com
- **Name**: John Doe
- **Company**: Corpfinity
- **Wellness Goals**: Stress Reduction, Better Sleep, Physical Fitness
- **Total Points**: 250
- **Notifications**: All enabled
- **Account Age**: 30 days

## Usage Examples

### Get All Wellness Pillars
```dart
final pillars = MockData.wellnessPillars;
```

### Get Activities by Pillar
```dart
final stressActivities = MockData.getActivitiesByPillar(
  MockData.pillarStressReduction
);
```

### Get Recommended Activities by Energy Level
```dart
final activities = MockData.getRecommendedActivities(
  energy: EnergyLevel.low,
  pillarId: MockData.pillarStressReduction,
);
```

### Get Activity by ID
```dart
final activity = MockData.getActivityById('activity-001');
```

### Get Pillar by ID
```dart
final pillar = MockData.getPillarById(MockData.pillarPhysicalFitness);
```

### Search Activities
```dart
final results = MockData.searchActivities('breathing');
```

### Get Mock User
```dart
final user = MockData.mockUser;
```

### Get All Badges
```dart
final badges = MockData.badges;
```

## Asset Requirements

The mock data references the following asset files that should be created:

### Icons (Pillars)
- `assets/icons/stress_reduction.png`
- `assets/icons/increased_energy.png`
- `assets/icons/better_sleep.png`
- `assets/icons/physical_fitness.png`
- `assets/icons/healthy_eating.png`
- `assets/icons/social_connection.png`

### Icons (Badges)
- `assets/icons/badge_first_step.png`
- `assets/icons/badge_3_day.png`
- `assets/icons/badge_week.png`
- `assets/icons/badge_stress.png`
- `assets/icons/badge_energy.png`
- `assets/icons/badge_sleep.png`
- `assets/icons/badge_fitness.png`
- `assets/icons/badge_explorer.png`
- `assets/icons/badge_century.png`
- `assets/icons/badge_social.png`

### Images (Activity Thumbnails)
- Various activity thumbnail images (20 total)
- Activity step instruction images (60+ images)
- Default avatar image

**Note**: For development, placeholder images can be used until final assets are created.

## Integration with Repositories

The mock data is designed to be used by repository implementations:

```dart
class ActivityRepositoryImpl implements ActivityRepository {
  @override
  Future<List<Activity>> getRecommendedActivities(
    EnergyLevel energy,
    String pillarId,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return MockData.getRecommendedActivities(
      energy: energy,
      pillarId: pillarId,
    );
  }
  
  // Other methods...
}
```

## Testing

The mock data can be used in unit tests and widget tests:

```dart
test('should filter activities by energy level', () {
  final activities = MockData.getRecommendedActivities(
    energy: EnergyLevel.low,
    pillarId: MockData.pillarStressReduction,
  );
  
  expect(activities.every((a) => a.difficulty == Difficulty.low), true);
});
```

## Future Enhancements

When integrating with the backend API:
1. Replace mock data calls with actual API calls
2. Implement caching layer using Hive
3. Add offline queue for activity completions
4. Sync local data with backend periodically

## Notes

- All activities have realistic durations (1-5 minutes)
- Activity steps include timer values where appropriate
- Tags are provided for enhanced search functionality
- Difficulty levels align with energy level recommendations
- All data follows the models defined in `lib/data/models/`
