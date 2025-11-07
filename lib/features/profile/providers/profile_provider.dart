import 'package:flutter/foundation.dart';
import '../../auth/models/user.dart';
import '../../auth/providers/auth_provider.dart';

/// ProfileProvider manages profile data and settings
/// 
/// Features:
/// - Manage profile data and settings
/// - Update notification preferences
/// - Handle settings changes and save to backend
/// - Implement logout functionality
/// - Manage voice guidance and privacy settings
/// - Handle language selection
class ProfileProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  
  bool _isLoading = false;
  String? _errorMessage;
  
  // Additional settings not in User model
  bool _voiceGuidanceEnabled = false;
  String _selectedLanguage = 'English';
  
  // Available languages
  static const List<String> availableLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  ProfileProvider(this._authProvider);

  // Getters
  User? get currentUser => _authProvider.currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get voiceGuidanceEnabled => _voiceGuidanceEnabled;
  String get selectedLanguage => _selectedLanguage;

  /// Update notification preferences
  /// 
  /// Updates the user's notification settings and saves to backend
  Future<void> updateNotificationPreferences({
    bool? enabled,
    bool? dailyReminders,
    bool? achievementAlerts,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      // Create updated preferences
      final updatedPreferences = currentUser!.notifications.copyWith(
        enabled: enabled,
        dailyReminders: dailyReminders,
        achievementAlerts: achievementAlerts,
      );

      // Update user with new preferences
      await _authProvider.updateProfile(
        name: currentUser!.name,
        company: currentUser!.company,
        wellnessGoals: currentUser!.wellnessGoals,
        notifications: updatedPreferences,
      );

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update notification preferences.');
      rethrow;
    }
  }

  /// Update voice guidance setting
  /// 
  /// Toggles voice guidance on/off
  Future<void> updateVoiceGuidance(bool enabled) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Save to backend when API is available
      await Future.delayed(const Duration(milliseconds: 300));

      _voiceGuidanceEnabled = enabled;

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update voice guidance setting.');
      rethrow;
    }
  }

  /// Update language preference
  /// 
  /// Changes the app language
  Future<void> updateLanguage(String language) async {
    try {
      _setLoading(true);
      _clearError();

      if (!availableLanguages.contains(language)) {
        throw Exception('Invalid language selection');
      }

      // TODO: Save to backend when API is available
      await Future.delayed(const Duration(milliseconds: 300));

      _selectedLanguage = language;

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update language preference.');
      rethrow;
    }
  }

  /// Update user profile information
  /// 
  /// Updates name, company, and wellness goals
  Future<void> updateProfile({
    String? name,
    String? company,
    List<String>? wellnessGoals,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      await _authProvider.updateProfile(
        name: name ?? currentUser!.name,
        company: company ?? currentUser!.company,
        wellnessGoals: wellnessGoals ?? currentUser!.wellnessGoals,
        notifications: currentUser!.notifications,
      );

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update profile.');
      rethrow;
    }
  }

  /// Logout the current user
  /// 
  /// Signs out and clears all user data
  Future<void> logout() async {
    try {
      _setLoading(true);
      _clearError();

      await _authProvider.signOut();

      // Reset local settings
      _voiceGuidanceEnabled = false;
      _selectedLanguage = 'English';

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to logout.');
      rethrow;
    }
  }

  /// Load user settings
  /// 
  /// Fetches user-specific settings from backend
  Future<void> loadSettings() async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Load from backend when API is available
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data for now
      _voiceGuidanceEnabled = false;
      _selectedLanguage = 'English';

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to load settings.');
    }
  }

  // Helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
