import '../models/models.dart';
import '../../core/exceptions/app_exception.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Sign up with email and password
  Future<User> signUp(String email, String password);

  /// Sign in with email and password
  Future<User> signIn(String email, String password);

  /// Sign in with SSO provider
  Future<User> signInWithSSO(SSOProvider provider);

  /// Sign out current user
  Future<void> signOut();

  /// Get current authenticated user
  Future<User?> getCurrentUser();
}

/// Mock implementation of AuthRepository for development
class MockAuthRepository implements AuthRepository {
  User? _currentUser;
  final Map<String, String> _mockUsers = {
    'test@example.com': 'password123',
    'demo@corpfinity.com': 'demo1234',
  };

  @override
  Future<User> signUp(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Validate email format
      if (!_isValidEmail(email)) {
        throw ValidationException('Invalid email format');
      }

      // Validate password length
      if (password.length < 8) {
        throw ValidationException('Password must be at least 8 characters');
      }

      // Check if user already exists
      if (_mockUsers.containsKey(email)) {
        throw AuthException('User already exists with this email');
      }

      // Create new user
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: '',
        wellnessGoals: [],
        notifications: const NotificationPreferences(
          enabled: true,
          dailyReminders: true,
          achievementAlerts: true,
        ),
        totalPoints: 0,
        createdAt: DateTime.now(),
      );

      _mockUsers[email] = password;
      _currentUser = user;

      return user;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<User> signIn(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Validate credentials
      if (!_mockUsers.containsKey(email)) {
        throw AuthException('No user found with this email');
      }

      if (_mockUsers[email] != password) {
        throw AuthException('Incorrect password');
      }

      // Return mock user
      final user = User(
        id: email.hashCode.toString(),
        email: email,
        name: _getMockNameFromEmail(email),
        company: 'Corpfinity Inc.',
        wellnessGoals: ['Stress Reduction', 'Better Sleep'],
        notifications: const NotificationPreferences(
          enabled: true,
          dailyReminders: true,
          achievementAlerts: true,
        ),
        totalPoints: 150,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      _currentUser = user;
      return user;
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<User> signInWithSSO(SSOProvider provider) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock SSO authentication
      final email = provider == SSOProvider.google
          ? 'user@gmail.com'
          : 'user@outlook.com';

      final user = User(
        id: email.hashCode.toString(),
        email: email,
        name: provider == SSOProvider.google ? 'Google User' : 'Microsoft User',
        company: provider == SSOProvider.google ? 'Google LLC' : 'Microsoft Corp',
        wellnessGoals: ['Increased Energy', 'Physical Fitness'],
        notifications: const NotificationPreferences(
          enabled: true,
          dailyReminders: true,
          achievementAlerts: true,
        ),
        totalPoints: 250,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      );

      _currentUser = user;
      return user;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AuthException('SSO authentication failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      _currentUser = null;
    } catch (e) {
      throw UnknownException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    return _currentUser;
  }

  // Helper methods

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String _getMockNameFromEmail(String email) {
    final username = email.split('@').first;
    return username
        .split('.')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
