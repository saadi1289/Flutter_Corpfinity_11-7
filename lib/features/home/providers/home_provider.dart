import 'dart:async';
import 'dart:ui' show Color;
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import '../../../data/models/user.dart';
import '../../../data/models/user_progress.dart';
import '../../../data/models/animation_config.dart';
import '../../../data/models/carousel_item.dart';
import '../../../core/utils/performance_monitor.dart';
import '../../../data/services/local_cache_service.dart';

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
  final AnimationConfig animationConfig;
  final int carouselIndex;
  final List<CarouselItem> featuredItems;
  final bool shouldReduceAnimations;

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
    this.animationConfig = const AnimationConfig(),
    this.carouselIndex = 0,
    this.featuredItems = const [],
    this.shouldReduceAnimations = false,
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
    AnimationConfig? animationConfig,
    int? carouselIndex,
    List<CarouselItem>? featuredItems,
    bool? shouldReduceAnimations,
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
      animationConfig: animationConfig ?? this.animationConfig,
      carouselIndex: carouselIndex ?? this.carouselIndex,
      featuredItems: featuredItems ?? this.featuredItems,
      shouldReduceAnimations: shouldReduceAnimations ?? this.shouldReduceAnimations,
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
        other.levelProgress == levelProgress &&
        other.animationConfig == animationConfig &&
        other.carouselIndex == carouselIndex &&
        other.shouldReduceAnimations == shouldReduceAnimations;
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
      Object.hash(animationConfig, carouselIndex, shouldReduceAnimations),
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

  // Performance monitor for tracking FPS and adjusting animation complexity
  PerformanceMonitor? _performanceMonitor;
  
  // Scroll position for parallax calculations
  double _scrollOffset = 0.0;
  
  // Requirement 17.2: Debounce timer for parallax offset calculations
  Timer? _scrollDebounce;
  static const _scrollDebounceDuration = Duration(milliseconds: 16);
  
  // Cache service for offline-first data strategy
  final LocalCacheService _cacheService = LocalCacheService();

  HomeState get state => _state;
  
  /// Current scroll offset for parallax calculations
  double get scrollOffset => _scrollOffset;

  // Convenience getters for stats
  int get currentStreak => _state.currentStreak;
  double get weeklyProgress => _state.weeklyProgress;
  int get totalActivities => _state.totalActivities;
  String get userName => _state.userName;
  String? get profileImageUrl => _state.profileImageUrl;
  int get currentLevel => _state.currentLevel;
  double get levelProgress => _state.levelProgress;
  AnimationConfig get animationConfig => _state.animationConfig;

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

  /// Fetch and update quick stats data with offline-first caching strategy
  /// 
  /// Requirements: 10.4, 11.5 - Implement offline-first data caching
  /// 
  /// Returns true if successful, false if an error occurred
  Future<bool> fetchQuickStats() async {
    // Try to load from cache first (offline-first strategy)
    if (_cacheService.isQuickStatsCacheValid()) {
      final cachedStats = _cacheService.getCachedQuickStats();
      if (cachedStats != null) {
        _updateStateFromQuickStats(cachedStats);
        notifyListeners();
        
        // Fetch fresh data in background without blocking UI
        _fetchQuickStatsInBackground();
        return true;
      }
    }
    
    // No valid cache, fetch from network
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      // TODO: Replace with actual repository call when backend is integrated
      // For now, using mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data - will be replaced with actual API call
      final stats = {
        'currentStreak': 5,
        'weeklyProgress': 0.6,
        'totalActivities': 23,
        'currentLevel': 5,
        'profileImageUrl': null,
      };
      
      // Cache the fetched data
      await _cacheService.cacheQuickStats(stats);
      
      // Enforce payload size limit
      await _cacheService.enforcePayloadLimit();
      
      _updateStateFromQuickStats(stats);
      
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      return true;
    } catch (e) {
      // On error, try to use cached data even if stale
      final cachedStats = _cacheService.getCachedQuickStats();
      if (cachedStats != null) {
        _updateStateFromQuickStats(cachedStats);
      }
      
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
      debugPrint('Error fetching quick stats: $e');
      return false;
    }
  }
  
  /// Update state from quick stats data
  void _updateStateFromQuickStats(Map<String, dynamic> stats) {
    _state = _state.copyWith(
      currentStreak: stats['currentStreak'] as int? ?? 0,
      weeklyProgress: (stats['weeklyProgress'] as num?)?.toDouble() ?? 0.0,
      totalActivities: stats['totalActivities'] as int? ?? 0,
      currentLevel: stats['currentLevel'] as int? ?? 1,
      profileImageUrl: stats['profileImageUrl'] as String?,
    );
    
    // Calculate level progress based on activities
    final progress = calculateLevelProgress();
    _state = _state.copyWith(levelProgress: progress);
  }
  
  /// Fetch quick stats in background without blocking UI
  Future<void> _fetchQuickStatsInBackground() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final stats = {
        'currentStreak': 5,
        'weeklyProgress': 0.6,
        'totalActivities': 23,
        'currentLevel': 5,
        'profileImageUrl': null,
      };
      
      // Update cache with fresh data
      await _cacheService.cacheQuickStats(stats);
      
      // Update state if data has changed
      _updateStateFromQuickStats(stats);
      notifyListeners();
    } catch (e) {
      // Silently fail background refresh
      debugPrint('Background refresh failed: $e');
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
    
    // Requirement 16.2: Announce state changes for screen readers
    SemanticsService.announce(
      'Activity completed. Total activities: ${_state.totalActivities}',
      TextDirection.ltr,
    );
    
    notifyListeners();
  }

  /// Update animation configuration
  /// Used to switch to reduced animations for accessibility or performance
  void updateAnimationConfig(AnimationConfig config) {
    _state = _state.copyWith(animationConfig: config);
    notifyListeners();
  }

  /// Enable reduced animation mode
  /// Typically called when reduced motion is detected or performance is low
  void enableReducedAnimations() {
    _state = _state.copyWith(animationConfig: AnimationConfig.reduced());
    notifyListeners();
  }

  /// Reset to default animation configuration
  void resetAnimationConfig() {
    _state = _state.copyWith(animationConfig: const AnimationConfig());
    notifyListeners();
  }

  /// Update carousel index when user swipes or auto-advance occurs
  void updateCarouselIndex(int index) {
    final previousIndex = _state.carouselIndex;
    _state = _state.copyWith(carouselIndex: index);
    
    // Requirement 16.2: Announce carousel changes for screen readers
    if (previousIndex != index && _state.featuredItems.isNotEmpty && index < _state.featuredItems.length) {
      final item = _state.featuredItems[index];
      SemanticsService.announce(
        'Showing ${item.title}. ${item.description}',
        TextDirection.ltr,
      );
    }
    
    notifyListeners();
  }

  /// Load featured items for the carousel
  /// This would typically fetch from a repository, but uses mock data for now
  Future<void> loadFeaturedItems() async {
    try {
      // TODO: Replace with actual repository call when backend is integrated
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock featured items with cohesive gradient colors
      final items = [
        CarouselItem(
          title: 'Mindful Meditation',
          description: 'Start your day with a 10-minute guided meditation',
          gradientColors: [
            const Color(0xFF667eea), // Soft purple
            const Color(0xFF764ba2), // Deep purple
          ],
        ),
        CarouselItem(
          title: 'Team Yoga Session',
          description: 'Join our weekly yoga class every Wednesday at 5 PM',
          gradientColors: [
            const Color(0xFF56ab2f), // Fresh green
            const Color(0xFFa8e063), // Light green
          ],
        ),
        CarouselItem(
          title: 'Wellness Challenge',
          description: 'Complete 30 days of daily activities and win rewards',
          gradientColors: [
            const Color(0xFFf093fb), // Soft pink
            const Color(0xFFf5576c), // Coral red
          ],
        ),
      ];
      
      _state = _state.copyWith(featuredItems: items);
      notifyListeners();
    } catch (e) {
      // Handle error silently for now
      debugPrint('Error loading featured items: $e');
    }
  }

  /// Initialize performance monitoring
  /// Should be called when the home screen is mounted
  void initializePerformanceMonitoring() {
    _performanceMonitor = PerformanceMonitor();
    _performanceMonitor!.onAnimationComplexityChanged = (shouldReduce) {
      adjustAnimationComplexity(shouldReduce);
    };
    _performanceMonitor!.startMonitoring();
  }

  /// Adjust animation complexity based on FPS performance
  /// Automatically called by PerformanceMonitor when FPS drops below threshold
  void adjustAnimationComplexity(bool shouldReduce) {
    if (_state.shouldReduceAnimations != shouldReduce) {
      _state = _state.copyWith(shouldReduceAnimations: shouldReduce);
      
      // Update animation config to reduced mode if needed
      if (shouldReduce) {
        _state = _state.copyWith(animationConfig: AnimationConfig.reduced());
        
        // Requirement 16.2: Announce performance adjustments for screen readers
        SemanticsService.announce(
          'Animations reduced for better performance',
          TextDirection.ltr,
        );
      } else {
        _state = _state.copyWith(animationConfig: const AnimationConfig());
        
        SemanticsService.announce(
          'Full animations restored',
          TextDirection.ltr,
        );
      }
      
      notifyListeners();
    }
  }

  /// Handle scroll position updates for parallax calculations
  /// Should be called from scroll listener in the UI
  /// 
  /// Requirement 17.2: Debounce parallax offset calculations to optimize performance
  /// Requirement 2.3: Maintain smooth parallax transitions without jank
  /// Requirement 12.4: Avoid layout recalculations during scroll
  /// 
  /// [offset] - Current scroll offset in pixels
  void handleScrollPosition(double offset) {
    // Cancel any pending debounce timer
    _scrollDebounce?.cancel();
    
    // Set up debounce timer to batch scroll updates
    _scrollDebounce = Timer(_scrollDebounceDuration, () {
      // Update scroll offset for parallax calculations
      // This is read directly by ParallaxBackground without triggering rebuilds
      _scrollOffset = offset;
      
      // Note: We don't call notifyListeners here to avoid excessive rebuilds
      // The parallax effect will read the offset directly when needed
      // This prevents layout recalculations during scroll
    });
  }

  /// Dispose of resources including performance monitor
  @override
  void dispose() {
    // Requirement 17.2: Clean up debounce timer
    _scrollDebounce?.cancel();
    _performanceMonitor?.dispose();
    super.dispose();
  }
}
