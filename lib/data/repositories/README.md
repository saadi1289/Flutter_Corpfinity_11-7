# Repository Layer

This directory contains the repository implementations for the Corpfinity Employee App. Repositories provide a clean abstraction layer between the business logic and data sources, handling data access, caching, and error handling.

## Overview

The repository layer follows the Repository Pattern, providing:
- **Abstraction**: Clean interfaces for data operations
- **Mock Data**: Development-ready mock implementations
- **Error Handling**: Consistent error handling across all operations
- **Local Storage**: Integration with Hive for offline-first functionality
- **Future-Ready**: Easy to swap mock implementations with real API calls

## Repository Implementations

### 1. AuthRepository (`auth_repository.dart`)

Handles user authentication operations.

**Interface Methods:**
- `signUp(email, password)` - Register new user with email/password
- `signIn(email, password)` - Authenticate existing user
- `signInWithSSO(provider)` - Authenticate with Google/Microsoft SSO
- `signOut()` - Sign out current user
- `getCurrentUser()` - Get currently authenticated user

**Mock Implementation:**
- Validates email format and password length
- Stores mock users in memory
- Simulates network delays (300-800ms)
- Provides pre-configured test accounts

**Test Accounts:**
```dart
'test@example.com' / 'password123'
'demo@corpfinity.com' / 'demo1234'
```

**Error Handling:**
- `ValidationException` - Invalid email format or password length
- `AuthException` - User already exists, incorrect credentials
- `UnknownException` - Unexpected errors

### 2. UserRepository (`user_repository.dart`)

Manages user profile and preferences with local storage.

**Interface Methods:**
- `getUser(userId)` - Fetch user by ID
- `updateUser(user)` - Update user information
- `updatePreferences(userId, prefs)` - Update notification preferences
- `saveUserLocally(user)` - Save to local storage
- `getCurrentUserLocally()` - Get from local storage
- `deleteUserLocally()` - Remove from local storage

**Implementation:**
- Uses Hive for persistent local storage
- Validates user data before saving
- Simulates network delays (200-400ms)
- Offline-first approach

**Error Handling:**
- `ValidationException` - Empty email or name
- `AuthException` - User not found
- `UnknownException` - Storage or unexpected errors

### 3. ActivityRepository (`activity_repository.dart`)

Provides access to wellness activities with mock data and caching.

**Interface Methods:**
- `getRecommendedActivities(energy, pillarId)` - Get filtered activities (3-5 results)
- `getAllActivities()` - Fetch all available activities
- `searchActivities(query)` - Search by name, description, or tags
- `getActivityById(id)` - Get specific activity
- `completeActivity(activityId)` - Record completion
- `cacheActivitiesLocally(activities)` - Cache to local storage
- `getCachedActivities()` - Retrieve cached activities

**Mock Data:**
Includes 15+ activities across all 6 wellness pillars:
- **Stress Reduction**: Deep Breathing, Progressive Muscle Relaxation, Mindful Observation
- **Increased Energy**: Desk Stretches, Power Pose, Quick Walk
- **Better Sleep**: Evening Wind-Down
- **Physical Fitness**: Office Cardio Burst
- **Healthy Eating**: Mindful Snacking
- **Social Connection**: Coffee Chat, Gratitude Message

**Caching:**
- 24-hour cache validity
- Automatic cache refresh when expired
- Stores activities in Hive

**Filtering:**
- By wellness pillar
- By energy level (maps to difficulty)
- By search query (name, description, tags)

**Error Handling:**
- `ValidationException` - Activity not found
- `UnknownException` - Data access or unexpected errors

### 4. ProgressRepository (`progress_repository.dart`)

Tracks user progress, streaks, and badges with local persistence.

**Interface Methods:**
- `getUserProgress(userId)` - Get complete progress data
- `getActivityHistory(userId)` - Get completed activities list
- `recordActivityCompletion(userId, activityId, activityName)` - Record new completion
- `updateStreak(userId, current, longest)` - Update streak counts
- `unlockBadge(userId, badgeId)` - Unlock achievement badge
- `saveProgressLocally(progress)` - Save to local storage
- `getProgressLocally(userId)` - Get from local storage

**Features:**
- **Streak Calculation**: Automatic calculation of current and longest streaks
- **Badge System**: 8 achievement badges with auto-unlock logic
- **Weekly Goals**: Tracks progress toward 5 activities per week
- **Activity History**: Maintains last 50 completed activities
- **Points System**: Awards 10 points per activity

**Badge Types:**
1. **Getting Started** - Complete 1 activity
2. **Wellness Explorer** - Complete 5 activities
3. **Wellness Enthusiast** - Complete 10 activities
4. **Wellness Champion** - Complete 25 activities
5. **Wellness Master** - Complete 50 activities
6. **Consistency Builder** - 3-day streak
7. **Week Warrior** - 7-day streak
8. **Dedication Legend** - 30-day streak

**Streak Logic:**
- Counts consecutive days with at least one activity
- Resets if no activity today or yesterday
- Tracks longest streak ever achieved

**Error Handling:**
- `UnknownException` - Storage or calculation errors

### 5. LocalStorageRepository (`local_storage_repository.dart`)

Low-level storage operations and sync management (existing implementation).

## Usage Examples

### Authentication Flow

```dart
// Initialize repository
final authRepo = MockAuthRepository();

// Sign up new user
try {
  final user = await authRepo.signUp(
    'user@example.com',
    'securepass123',
  );
  print('User created: ${user.name}');
} on ValidationException catch (e) {
  print('Validation error: ${e.message}');
} on AuthException catch (e) {
  print('Auth error: ${e.message}');
}

// Sign in existing user
final user = await authRepo.signIn(
  'test@example.com',
  'password123',
);

// SSO authentication
final user = await authRepo.signInWithSSO(SSOProvider.google);
```

### User Profile Management

```dart
final userRepo = LocalUserRepository();

// Get user
final user = await userRepo.getUser(userId);

// Update profile
final updatedUser = user.copyWith(
  name: 'John Doe',
  company: 'Acme Corp',
);
await userRepo.updateUser(updatedUser);

// Update preferences
await userRepo.updatePreferences(
  userId,
  NotificationPreferences(
    enabled: true,
    dailyReminders: false,
    achievementAlerts: true,
  ),
);
```

### Activity Discovery

```dart
final activityRepo = MockActivityRepository();

// Get recommended activities
final activities = await activityRepo.getRecommendedActivities(
  EnergyLevel.medium,
  'stress_reduction',
);

// Search activities
final results = await activityRepo.searchActivities('breathing');

// Get specific activity
final activity = await activityRepo.getActivityById('sr_1');

// Complete activity
await activityRepo.completeActivity('sr_1');
```

### Progress Tracking

```dart
final progressRepo = LocalProgressRepository();

// Get user progress
final progress = await progressRepo.getUserProgress(userId);
print('Current streak: ${progress.currentStreak}');
print('Total activities: ${progress.totalActivitiesCompleted}');

// Record activity completion
await progressRepo.recordActivityCompletion(
  userId,
  'sr_1',
  'Deep Breathing Exercise',
);

// Check for new badges
final updatedProgress = await progressRepo.getUserProgress(userId);
final newBadges = updatedProgress.earnedBadges
    .where((b) => b.isUnlocked)
    .toList();
```

## Error Handling Strategy

All repositories follow consistent error handling:

1. **Catch and Wrap**: Catch all exceptions and wrap in appropriate `AppException` types
2. **Preserve Context**: Include original error message in wrapped exceptions
3. **Rethrow AppExceptions**: Don't double-wrap existing `AppException` instances
4. **Simulate Network**: Add realistic delays to mock implementations

```dart
try {
  // Repository operation
  final result = await repository.someMethod();
} on ValidationException catch (e) {
  // Handle validation errors (user input issues)
} on AuthException catch (e) {
  // Handle authentication errors (credentials, permissions)
} on NetworkException catch (e) {
  // Handle network errors (connectivity issues)
} on UnknownException catch (e) {
  // Handle unexpected errors (log and show generic message)
}
```

## Testing Considerations

### Mock Data Benefits
- **No Backend Required**: Develop and test without API dependencies
- **Predictable Results**: Consistent data for testing
- **Fast Iteration**: No network latency
- **Offline Development**: Work anywhere

### Transitioning to Real API
When ready to integrate with backend:

1. Create new implementations (e.g., `ApiAuthRepository`)
2. Implement same interfaces
3. Use Dio for HTTP calls
4. Keep mock implementations for testing
5. Use dependency injection to swap implementations

```dart
// Development
final authRepo = MockAuthRepository();

// Production
final authRepo = ApiAuthRepository(
  apiClient: DioClient(),
  tokenStorage: SecureStorage(),
);
```

## Dependencies

- **hive/hive_flutter**: Local storage
- **models**: Data models and enums
- **exceptions**: Error types

## Future Enhancements

- [ ] Add API implementations for production
- [ ] Implement token refresh logic
- [ ] Add request caching layer
- [ ] Implement optimistic updates
- [ ] Add retry logic for failed requests
- [ ] Implement data synchronization
- [ ] Add analytics tracking
- [ ] Implement rate limiting

## Related Files

- `lib/data/models/` - Data models
- `lib/data/services/` - Storage services
- `lib/core/exceptions/` - Exception types
- `lib/features/*/providers/` - State management (consumers of repositories)
