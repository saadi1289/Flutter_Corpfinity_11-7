import 'package:flutter/foundation.dart';
import '../../../data/models/user.dart';
import '../../../data/models/user_progress.dart';

/// Energy level enum for user selection
enum EnergyLevel {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case EnergyLevel.low:
        return 'Low Energy';
      case EnergyLevel.medium:
        return 'Medium Energy';
      case EnergyLevel.high:
        return 'High Energy';
    }
  }

  String get description {
    switch (this) {
      case EnergyLevel.low:
        return 'Gentle activities to recharge';
      case EnergyLevel.medium:
        return 'Balanced activities for focus';
      case EnergyLevel.high:
        return 'Active exercises to energize';
    }
  }
}

/// HomeState manages the state for the home screen
class HomeState {
  final String userName;
  final int currentStreak;
  final double weeklyProgress;
  final int totalActivities;
  final EnergyLevel? selectedEnergy;
  final bool isLoading;
  final String? profileImageUrl;
  final int currentLevel;
  final double levelProgress;

  const HomeState({
    required this.userName,
    required this.currentStreak,
    required this.weeklyProgress,
    required this.totalActivities,
    this.selectedEnergy,
    this.isLoading = false,
    this.profileImageUrl,
    this.currentLevel = 1,
    this.levelProgress = 0.0,
  });

  HomeState copyWith({
    String? userName,
    int? currentStreak,
    double? weeklyProgress,
    int? totalActivities,
    EnergyLevel? selectedEnergy,
    bool? isLoading,
    String? profileImageUrl,
    int? currentLevel,
    double? levelProgress,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      currentStreak: currentStreak ?? this.currentStreak,
      weeklyProgress: weeklyProgress ?? this.weeklyProgress,
      totalActivities: totalActivities ?? this.totalActivities,
      selectedEnergy: selectedEnergy ?? this.selectedEnergy,
      isLoading: isLoading ?? this.isLoading,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      currentLevel: currentLevel ?? this.currentLevel,
      levelProgress: levelProgress ?? this.levelProgress,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeState &&
        other.userName == userName &&
        other.currentStreak == currentStreak &&
        other.weeklyProgress == weeklyProgress &&
        other.totalActivities == totalActivities &&
        other.selectedEnergy == selectedEnergy &&
        other.isLoading == isLoading &&
        other.profileImageUrl == profileImageUrl &&
        other.currentLevel == currentLevel &&
        other.levelProgress == levelProgress;
  }

  @override
  int get hashCode {
    return Object.hash(
      userName,
      currentStreak,
      weeklyProgress,
      totalActivities,
      selectedEnergy,
      isLoading,
      profileImageUrl,
      currentLevel,
      levelProgress,
    );
  }
}

/// HomeProvider manages home screen state and business logic
class HomeProvider extends ChangeNotifier {
  HomeState _state = const HomeState(
    userName: 'User',
    currentStreak: 0,
    weeklyProgress: 0.0,
    totalActivities: 0,
  );

  HomeState get state => _state;

  // Convenience getters for stats
  int get currentStreak => _state.currentStreak;
  double get weeklyProgress => _state.weeklyProgress;
  int get totalActivities => _state.totalActivities;
  String get userName => _state.userName;
  String? get profileImageUrl => _state.profileImageUrl;
  int get currentLevel => _state.currentLevel;
  double get levelProgress => _state.levelProgress;

  /// Initialize home screen with user data and progress
  Future<void> initialize(User user, UserProgress progress) async {
    _state = HomeState(
      userName: user.name,
      currentStreak: progress.currentStreak,
      weeklyProgress: progress.weeklyGoalProgress,
      totalActivities: progress.totalActivitiesCompleted,
      isLoading: false,
    );
    notifyListeners();
  }

  /// Update energy level selection
  void selectEnergyLevel(EnergyLevel energy) {
    _state = _state.copyWith(selectedEnergy: energy);
    notifyListeners();
  }

  /// Clear energy level selection
  void clearEnergySelection() {
    _state = _state.copyWith(selectedEnergy: null);
    notifyListeners();
  }

  /// Fetch and update user profile data
  Future<void> fetchUserProfile() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // TODO: Replace with actual repository call when backend is integrated
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock profile data - will be replaced with actual API call
      _state = _state.copyWith(
        userName: 'John Doe',
        profileImageUrl: null, // No profile image for now
        currentLevel: 5,
        totalActivities: 23,
        isLoading: false,
      );
      
      // Calculate level progress based on activities
      final progress = calculateLevelProgress();
      _state = _state.copyWith(levelProgress: progress);
      
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      rethrow;
    }
  }

  /// Calculate level progress based on total activities
  /// Returns a value between 0.0 and 1.0
  double calculateLevelProgress() {
    // Each level requires 10 activities to complete
    const activitiesPerLevel = 10;
    
    // Calculate activities in current level
    final activitiesInCurrentLevel = _state.totalActivities % activitiesPerLevel;
    
    // Calculate progress as a percentage (0.0 to 1.0)
    final progress = activitiesInCurrentLevel / activitiesPerLevel;
    
    return progress.clamp(0.0, 1.0);
  }

  /// Fetch and update quick stats data
  Future<void> fetchQuickStats() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // TODO: Replace with actual repository call when backend is integrated
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - will be replaced with actual API call
      _state = _state.copyWith(
        currentStreak: 5,
        weeklyProgress: 0.6,
        totalActivities: 23,
        currentLevel: 5,
        profileImageUrl: null,
        isLoading: false,
      );
      
      // Calculate level progress based on activities
      final progress = calculateLevelProgress();
      _state = _state.copyWith(levelProgress: progress);
      
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      rethrow;
    }
  }

  /// Update user name
  void updateUserName(String name) {
    _state = _state.copyWith(userName: name);
    notifyListeners();
  }

  /// Update streak count
  void updateStreak(int streak) {
    _state = _state.copyWith(currentStreak: streak);
    notifyListeners();
  }

  /// Update weekly progress
  void updateWeeklyProgress(double progress) {
    _state = _state.copyWith(weeklyProgress: progress);
    notifyListeners();
  }

  /// Update total activities count
  void updateTotalActivities(int count) {
    _state = _state.copyWith(totalActivities: count);
    notifyListeners();
  }

  /// Increment activity count (called after completing an activity)
  void incrementActivityCount() {
    _state = _state.copyWith(
      totalActivities: _state.totalActivities + 1,
      weeklyProgress: (_state.weeklyProgress + 0.14).clamp(0.0, 1.0), // Assuming 7 activities per week goal
    );
    notifyListeners();
  }
}
