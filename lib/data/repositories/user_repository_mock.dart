import '../mock_data.dart';
import '../models/user.dart';
import '../models/notification_preferences.dart';

/// Mock implementation of UserRepository using MockData
/// This can be used for development and testing before backend integration
class UserRepositoryMock {
  User? _currentUser;

  /// Get current user
  Future<User?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser ?? MockData.mockUser;
  }

  /// Get user by ID
  Future<User?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (userId == MockData.mockUser.id) {
      return _currentUser ?? MockData.mockUser;
    }
    return null;
  }

  /// Update user profile
  Future<User> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _currentUser = user;
    return user;
  }

  /// Update notification preferences
  Future<void> updatePreferences(NotificationPreferences prefs) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(notifications: prefs);
    }
  }

  /// Update user points
  Future<User> updatePoints(int points) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final currentUser = _currentUser ?? MockData.mockUser;
    final updatedUser = currentUser.copyWith(totalPoints: points);
    _currentUser = updatedUser;
    return updatedUser;
  }

  /// Add points to user
  Future<User> addPoints(int pointsToAdd) async {
    final currentUser = _currentUser ?? MockData.mockUser;
    final newTotal = currentUser.totalPoints + pointsToAdd;
    return updatePoints(newTotal);
  }

  /// Reset to mock user (for testing)
  void reset() {
    _currentUser = null;
  }
}
