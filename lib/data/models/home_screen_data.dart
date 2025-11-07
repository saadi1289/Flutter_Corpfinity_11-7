import 'user_profile.dart';
import 'daily_progress.dart';

/// Home screen data model containing all information for the home screen
class HomeScreenData {
  final UserProfile profile;
  final DailyProgress dailyProgress;
  final String tipOfTheDay;
  final int currentStreak;

  const HomeScreenData({
    required this.profile,
    required this.dailyProgress,
    required this.tipOfTheDay,
    required this.currentStreak,
  });

  /// List of tips of the day variations
  static const List<String> _tipsOfTheDay = [
    'Take a 5-minute walk break every hour to boost energy and focus',
    'Stay hydrated! Aim for 8 glasses of water throughout your workday',
    'Practice the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds',
    'Deep breathing for just 2 minutes can significantly reduce stress levels',
    'Stand up and stretch every 30 minutes to prevent muscle tension',
    'A quick desk workout can improve your mood and productivity',
    'Take your lunch break away from your desk for better mental clarity',
    'Set boundaries with work notifications to protect your personal time',
    'Connect with a colleague today - social wellness matters too',
    'Celebrate small wins! Acknowledge your progress, no matter how small',
  ];

  /// Get mock data for development and testing
  static HomeScreenData getMockData() {
    // Use current time to vary the tip shown
    final tipIndex = DateTime.now().day % _tipsOfTheDay.length;
    
    return HomeScreenData(
      profile: const UserProfile(
        name: 'John Doe',
        imageUrl: null, // No image for mock data
        level: 5,
        levelProgress: 0.65,
      ),
      dailyProgress: const DailyProgress(
        completedActivities: 3,
        goalActivities: 5,
      ),
      tipOfTheDay: _tipsOfTheDay[tipIndex],
      currentStreak: 7,
    );
  }

  /// Get mock data with custom values
  static HomeScreenData getMockDataCustom({
    required String userName,
    String? userImageUrl,
    required int level,
    required double levelProgress,
    required int completedActivities,
    required int goalActivities,
    required int streak,
    String? customTip,
  }) {
    final tipIndex = DateTime.now().day % _tipsOfTheDay.length;
    
    return HomeScreenData(
      profile: UserProfile(
        name: userName,
        imageUrl: userImageUrl,
        level: level,
        levelProgress: levelProgress,
      ),
      dailyProgress: DailyProgress(
        completedActivities: completedActivities,
        goalActivities: goalActivities,
      ),
      tipOfTheDay: customTip ?? _tipsOfTheDay[tipIndex],
      currentStreak: streak,
    );
  }

  /// Create from JSON
  factory HomeScreenData.fromJson(Map<String, dynamic> json) {
    return HomeScreenData(
      profile: UserProfile.fromJson(json['profile'] as Map<String, dynamic>),
      dailyProgress: DailyProgress.fromJson(json['dailyProgress'] as Map<String, dynamic>),
      tipOfTheDay: json['tipOfTheDay'] as String,
      currentStreak: json['currentStreak'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'dailyProgress': dailyProgress.toJson(),
      'tipOfTheDay': tipOfTheDay,
      'currentStreak': currentStreak,
    };
  }

  /// Create a copy with updated fields
  HomeScreenData copyWith({
    UserProfile? profile,
    DailyProgress? dailyProgress,
    String? tipOfTheDay,
    int? currentStreak,
  }) {
    return HomeScreenData(
      profile: profile ?? this.profile,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      tipOfTheDay: tipOfTheDay ?? this.tipOfTheDay,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }
}
