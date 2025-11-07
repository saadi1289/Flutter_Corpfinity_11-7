import '../mock_data.dart';
import '../models/badge.dart';

/// Mock implementation of BadgeRepository using MockData
/// This can be used for development and testing before backend integration
class BadgeRepositoryMock {
  final List<Badge> _userBadges = List.from(MockData.badges);

  /// Get all badges (both locked and unlocked)
  Future<List<Badge>> getAllBadges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_userBadges);
  }

  /// Get unlocked badges only
  Future<List<Badge>> getUnlockedBadges() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _userBadges.where((badge) => badge.isUnlocked).toList();
  }

  /// Get locked badges only
  Future<List<Badge>> getLockedBadges() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _userBadges.where((badge) => !badge.isUnlocked).toList();
  }

  /// Unlock a badge
  Future<Badge?> unlockBadge(String badgeId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _userBadges.indexWhere((b) => b.id == badgeId);
    if (index == -1) return null;

    final badge = _userBadges[index];
    if (badge.isUnlocked) return badge; // Already unlocked

    final unlockedBadge = badge.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
    
    _userBadges[index] = unlockedBadge;
    return unlockedBadge;
  }

  /// Check if badge should be unlocked based on criteria
  /// This is a simplified version - real implementation would check actual user progress
  Future<List<Badge>> checkAndUnlockBadges({
    required int totalActivities,
    required int currentStreak,
    required Map<String, int> activitiesByPillar,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final newlyUnlocked = <Badge>[];

    // First Step - Complete first activity
    if (totalActivities >= 1) {
      final badge = await _unlockBadgeIfLocked('badge-001');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // 3-Day Streak
    if (currentStreak >= 3) {
      final badge = await _unlockBadgeIfLocked('badge-002');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Week Warrior - 7 day streak
    if (currentStreak >= 7) {
      final badge = await _unlockBadgeIfLocked('badge-003');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Stress Buster - 5 stress reduction activities
    if ((activitiesByPillar[MockData.pillarStressReduction] ?? 0) >= 5) {
      final badge = await _unlockBadgeIfLocked('badge-004');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Energy Booster - 5 energy activities
    if ((activitiesByPillar[MockData.pillarIncreasedEnergy] ?? 0) >= 5) {
      final badge = await _unlockBadgeIfLocked('badge-005');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Sleep Champion - 5 sleep activities
    if ((activitiesByPillar[MockData.pillarBetterSleep] ?? 0) >= 5) {
      final badge = await _unlockBadgeIfLocked('badge-006');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Fitness Fan - 10 fitness activities
    if ((activitiesByPillar[MockData.pillarPhysicalFitness] ?? 0) >= 10) {
      final badge = await _unlockBadgeIfLocked('badge-007');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Wellness Explorer - at least one from each pillar
    if (activitiesByPillar.length >= 6 && 
        activitiesByPillar.values.every((count) => count > 0)) {
      final badge = await _unlockBadgeIfLocked('badge-008');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Century Club - 100 activities
    if (totalActivities >= 100) {
      final badge = await _unlockBadgeIfLocked('badge-009');
      if (badge != null) newlyUnlocked.add(badge);
    }

    // Social Butterfly - 5 social activities
    if ((activitiesByPillar[MockData.pillarSocialConnection] ?? 0) >= 5) {
      final badge = await _unlockBadgeIfLocked('badge-010');
      if (badge != null) newlyUnlocked.add(badge);
    }

    return newlyUnlocked;
  }

  /// Helper method to unlock badge if it's currently locked
  Future<Badge?> _unlockBadgeIfLocked(String badgeId) async {
    final index = _userBadges.indexWhere((b) => b.id == badgeId);
    if (index == -1) return null;

    final badge = _userBadges[index];
    if (badge.isUnlocked) return null; // Already unlocked

    final unlockedBadge = badge.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );
    
    _userBadges[index] = unlockedBadge;
    return unlockedBadge;
  }

  /// Reset all badges to locked state (for testing)
  void reset() {
    _userBadges.clear();
    _userBadges.addAll(MockData.badges);
  }
}
