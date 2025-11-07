import '../models/models.dart';
import '../services/hive_service.dart';
import '../../core/exceptions/app_exception.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Get user by ID
  Future<User> getUser(String userId);

  /// Update user information
  Future<User> updateUser(User user);

  /// Update notification preferences
  Future<void> updatePreferences(String userId, NotificationPreferences prefs);

  /// Save user to local storage
  Future<void> saveUserLocally(User user);

  /// Get current user from local storage
  User? getCurrentUserLocally();

  /// Delete user from local storage
  Future<void> deleteUserLocally();
}

/// Implementation of UserRepository with local storage
class LocalUserRepository implements UserRepository {
  static const String _currentUserKey = 'current_user';

  @override
  Future<User> getUser(String userId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Try to get from local storage first
      final localUser = getCurrentUserLocally();
      if (localUser != null && localUser.id == userId) {
        return localUser;
      }

      // If not found locally, throw exception
      throw AuthException('User not found');
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<User> updateUser(User user) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));

      // Validate user data
      if (user.email.isEmpty) {
        throw ValidationException('Email cannot be empty');
      }

      if (user.name.isEmpty) {
        throw ValidationException('Name cannot be empty');
      }

      // Save to local storage
      await saveUserLocally(user);

      return user;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePreferences(
    String userId,
    NotificationPreferences prefs,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Get current user
      final currentUser = getCurrentUserLocally();
      if (currentUser == null || currentUser.id != userId) {
        throw AuthException('User not found');
      }

      // Update user with new preferences
      final updatedUser = currentUser.copyWith(notifications: prefs);
      await saveUserLocally(updatedUser);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to update preferences: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUserLocally(User user) async {
    try {
      await HiveService.userBox.put(_currentUserKey, user);
    } catch (e) {
      throw UnknownException('Failed to save user locally: ${e.toString()}');
    }
  }

  @override
  User? getCurrentUserLocally() {
    try {
      return HiveService.userBox.get(_currentUserKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteUserLocally() async {
    try {
      await HiveService.userBox.delete(_currentUserKey);
    } catch (e) {
      throw UnknownException('Failed to delete user locally: ${e.toString()}');
    }
  }
}
