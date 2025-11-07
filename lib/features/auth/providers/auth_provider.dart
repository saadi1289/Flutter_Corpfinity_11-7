import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../../../core/exceptions/app_exception.dart';

/// AuthProvider manages authentication state and operations
/// 
/// Features:
/// - Sign up with email/password
/// - Sign in with email/password
/// - SSO authentication (Google, Microsoft)
/// - User session management
/// - Secure token storage
/// - Auto-navigation after authentication
class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  /// Sign up with email and password
  /// 
  /// Returns the created user on success
  /// Throws AuthException on failure
  Future<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with actual API call
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock user creation
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: '', // Will be set in profile setup
        wellnessGoals: [],
        notifications: NotificationPreferences(),
        createdAt: DateTime.now(),
      );

      // Store authentication token
      await _storeAuthToken('mock_token_${user.id}');
      await _secureStorage.write(key: _userIdKey, value: user.id);

      _currentUser = user;
      _setLoading(false);
      notifyListeners();

      return user;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to create account. Please try again.');
      throw AuthException('Sign up failed: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  /// 
  /// Returns the authenticated user on success
  /// Throws AuthException on failure
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with actual API call
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock user authentication
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: 'John Doe',
        company: 'Corpfinity',
        wellnessGoals: ['Stress Reduction', 'Better Sleep'],
        notifications: NotificationPreferences(),
        totalPoints: 150,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      // Store authentication token
      await _storeAuthToken('mock_token_${user.id}');
      await _secureStorage.write(key: _userIdKey, value: user.id);

      _currentUser = user;
      _setLoading(false);
      notifyListeners();

      return user;
    } catch (e) {
      _setLoading(false);
      _setError('Invalid email or password.');
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  /// Sign in with SSO provider (Google or Microsoft)
  /// 
  /// Returns the authenticated user on success
  /// Throws AuthException on failure
  Future<User> signInWithSSO(SSOProvider provider) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with actual SSO implementation
      // Simulate SSO flow
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock user from SSO
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: 'user@${provider.name}.com',
        name: '', // Will be set in profile setup
        company: provider == SSOProvider.microsoft ? 'Corpfinity' : null,
        wellnessGoals: [],
        notifications: NotificationPreferences(),
        createdAt: DateTime.now(),
      );

      // Store authentication token
      await _storeAuthToken('mock_sso_token_${user.id}');
      await _secureStorage.write(key: _userIdKey, value: user.id);

      _currentUser = user;
      _setLoading(false);
      notifyListeners();

      return user;
    } catch (e) {
      _setLoading(false);
      _setError('SSO authentication failed. Please try again.');
      throw AuthException('SSO sign in failed: ${e.toString()}');
    }
  }

  /// Update user profile information
  /// 
  /// Used after profile setup to complete user registration
  Future<void> updateProfile({
    required String name,
    String? company,
    required List<String> wellnessGoals,
    required NotificationPreferences notifications,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentUser == null) {
        throw AuthException('No authenticated user');
      }

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = _currentUser!.copyWith(
        name: name,
        company: company,
        wellnessGoals: wellnessGoals,
        notifications: notifications,
      );

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      _setError('Failed to update profile.');
      throw AuthException('Profile update failed: ${e.toString()}');
    }
  }

  /// Sign out the current user
  /// 
  /// Clears all stored authentication data
  Future<void> signOut() async {
    try {
      _setLoading(true);

      // Clear stored tokens
      await _secureStorage.delete(key: _tokenKey);
      await _secureStorage.delete(key: _userIdKey);

      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  /// Check if user has a valid session
  /// 
  /// Attempts to restore user session from stored token
  Future<bool> checkAuthStatus() async {
    try {
      final token = await _secureStorage.read(key: _tokenKey);
      final userId = await _secureStorage.read(key: _userIdKey);

      if (token == null || userId == null) {
        return false;
      }

      // TODO: Validate token with backend and fetch user data
      // For now, just check if token exists
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Store authentication token securely
  Future<void> _storeAuthToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Get stored authentication token
  Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _tokenKey);
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
