/// Example usage of MockData and Mock Repositories
/// 
/// This file demonstrates how to use the mock data in your application
/// during development and testing.
library;

import 'mock_data.dart';
import 'models/enums.dart';
import 'repositories/activity_repository_mock.dart';
import 'repositories/badge_repository_mock.dart';
import 'repositories/user_repository_mock.dart';
import 'repositories/wellness_pillar_repository_mock.dart';

void main() async {
  // Example 1: Direct access to mock data
  print('=== Example 1: Direct Mock Data Access ===');
  
  // Get all wellness pillars
  final pillars = MockData.wellnessPillars;
  print('Total pillars: ${pillars.length}');
  for (final pillar in pillars) {
    print('- ${pillar.name}: ${pillar.availableActivities} activities');
  }
  
  // Get activities for a specific pillar
  final stressActivities = MockData.getActivitiesByPillar(
    MockData.pillarStressReduction,
  );
  print('\nStress Reduction Activities: ${stressActivities.length}');
  for (final activity in stressActivities) {
    print('- ${activity.name} (${activity.durationMinutes} min, ${activity.difficulty.displayName})');
  }
  
  // Get recommended activities based on energy level
  final lowEnergyActivities = MockData.getRecommendedActivities(
    energy: EnergyLevel.low,
    pillarId: MockData.pillarPhysicalFitness,
  );
  print('\nLow Energy Physical Fitness Activities: ${lowEnergyActivities.length}');
  
  // Search activities
  final breathingActivities = MockData.searchActivities('breathing');
  print('\nActivities matching "breathing": ${breathingActivities.length}');
  
  // Get mock user
  final user = MockData.mockUser;
  print('\nMock User: ${user.name} (${user.email})');
  print('Points: ${user.totalPoints}');
  print('Goals: ${user.wellnessGoals.join(", ")}');
  
  // Get badges
  final badges = MockData.badges;
  print('\nTotal Badges: ${badges.length}');
  
  print('\n=== Example 2: Using Mock Repositories ===');
  
  // Initialize mock repositories
  final activityRepo = ActivityRepositoryMock();
  final pillarRepo = WellnessPillarRepositoryMock();
  final userRepo = UserRepositoryMock();
  final badgeRepo = BadgeRepositoryMock();
  
  // Get recommended activities (with simulated network delay)
  print('\nFetching recommended activities...');
  final recommended = await activityRepo.getRecommendedActivities(
    energy: EnergyLevel.medium,
    pillarId: MockData.pillarIncreasedEnergy,
  );
  print('Recommended: ${recommended.length} activities');
  
  // Get all pillars
  print('\nFetching wellness pillars...');
  final allPillars = await pillarRepo.getAllPillars();
  print('Loaded ${allPillars.length} pillars');
  
  // Get current user
  print('\nFetching current user...');
  final currentUser = await userRepo.getCurrentUser();
  print('User: ${currentUser?.name}');
  
  // Get badges
  print('\nFetching badges...');
  final allBadges = await badgeRepo.getAllBadges();
  final unlockedBadges = await badgeRepo.getUnlockedBadges();
  print('Total badges: ${allBadges.length}');
  print('Unlocked: ${unlockedBadges.length}');
  
  // Simulate unlocking a badge
  print('\nUnlocking "First Step" badge...');
  final unlockedBadge = await badgeRepo.unlockBadge('badge-001');
  if (unlockedBadge != null) {
    print('Badge unlocked: ${unlockedBadge.name}');
    print('Unlocked at: ${unlockedBadge.unlockedAt}');
  }
  
  // Check for badge unlocks based on progress
  print('\nChecking for badge unlocks...');
  final newBadges = await badgeRepo.checkAndUnlockBadges(
    totalActivities: 5,
    currentStreak: 3,
    activitiesByPillar: {
      MockData.pillarStressReduction: 2,
      MockData.pillarPhysicalFitness: 3,
    },
  );
  print('Newly unlocked badges: ${newBadges.length}');
  for (final badge in newBadges) {
    print('- ${badge.name}');
  }
  
  // Update user points
  print('\nAdding points to user...');
  final updatedUser = await userRepo.addPoints(50);
  print('New total points: ${updatedUser.totalPoints}');
  
  // Search activities
  print('\nSearching for "stretch" activities...');
  final searchResults = await activityRepo.searchActivities('stretch');
  print('Found ${searchResults.length} activities');
  for (final activity in searchResults) {
    print('- ${activity.name}');
  }
  
  // Get specific activity with steps
  print('\nFetching activity details...');
  final activity = await activityRepo.getActivityById('activity-001');
  if (activity != null) {
    print('Activity: ${activity.name}');
    print('Steps: ${activity.steps.length}');
    for (final step in activity.steps) {
      print('  ${step.stepNumber}. ${step.title}');
      if (step.timerSeconds != null) {
        print('     Timer: ${step.timerSeconds}s');
      }
    }
  }
  
  print('\n=== Example 3: Activity Filtering ===');
  
  // Get all activities
  final allActivities = MockData.activities;
  
  // Filter by difficulty
  final easyActivities = allActivities.where(
    (a) => a.difficulty == Difficulty.low,
  ).toList();
  print('Easy activities: ${easyActivities.length}');
  
  // Filter by duration
  final quickActivities = allActivities.where(
    (a) => a.durationMinutes <= 2,
  ).toList();
  print('Quick activities (≤2 min): ${quickActivities.length}');
  
  // Filter by location
  final deskActivities = allActivities.where(
    (a) => a.location == 'At Desk',
  ).toList();
  print('At Desk activities: ${deskActivities.length}');
  
  // Filter by tags
  final relaxationActivities = allActivities.where(
    (a) => a.tags.contains('relaxation'),
  ).toList();
  print('Relaxation activities: ${relaxationActivities.length}');
  
  print('\n=== Example 4: Pillar Statistics ===');
  
  for (final pillar in MockData.wellnessPillars) {
    final activities = MockData.getActivitiesByPillar(pillar.id);
    final avgDuration = activities.isEmpty 
        ? 0 
        : activities.map((a) => a.durationMinutes).reduce((a, b) => a + b) / activities.length;
    
    print('\n${pillar.name}:');
    print('  Activities: ${activities.length}');
    print('  Avg Duration: ${avgDuration.toStringAsFixed(1)} min');
    print('  Difficulties: ${activities.map((a) => a.difficulty.displayName).toSet().join(", ")}');
  }
}
