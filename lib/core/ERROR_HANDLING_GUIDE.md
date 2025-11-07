# Error Handling Guide

This guide explains the error handling system implemented in the Corpfinity Employee App.

## Overview

The app uses a comprehensive error handling system that includes:

1. **Exception Hierarchy** - Typed exceptions for different error scenarios
2. **Form Validators** - Reusable validation functions for user input
3. **Error UI Components** - Consistent error display widgets
4. **Retry Logic** - Automatic retry for network operations
5. **Centralized Error Handler** - Unified error handling across the app

## Exception Hierarchy

### Base Exception

All app exceptions extend from `AppException`:

```dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, [this.code]);
}
```

### Exception Types

#### NetworkException
Used for network-related errors (connection failures, timeouts, etc.)

```dart
throw NetworkException('Failed to connect to server');
```

#### AuthException
Used for authentication and authorization errors

```dart
throw AuthException('Invalid credentials');
```

#### ValidationException
Used for data validation errors

```dart
throw ValidationException('Email format is invalid');
```

#### UnknownException
Used for unexpected errors

```dart
throw UnknownException('An unexpected error occurred');
```

## Form Validators

The `Validators` class provides reusable validation functions:

### Email Validation

```dart
TextFormField(
  validator: Validators.validateEmail,
  // Returns: 'Email is required' or 'Please enter a valid email address'
)
```

### Password Validation

```dart
TextFormField(
  validator: Validators.validatePassword,
  // Returns: 'Password is required' or 'Password must be at least 8 characters'
)
```

### Required Field Validation

```dart
TextFormField(
  validator: (value) => Validators.validateRequired(value, 'Name'),
  // Returns: 'Name is required'
)
```

## Error UI Components

### 1. ErrorSnackBar

For temporary, non-critical error messages:

```dart
// Show error
ErrorSnackBar.show(context, 'Unable to connect to server');

// Show success
ErrorSnackBar.showSuccess(context, 'Activity completed!');
```

**Features:**
- Auto-dismisses after 4 seconds (error) or 3 seconds (success)
- Includes icon and dismiss button
- Floating style with rounded corners
- Color-coded (red for errors, green for success)

### 2. ErrorDialog

For critical errors requiring user acknowledgment:

```dart
// With retry option
ErrorDialog.show(
  context,
  title: 'Connection Error',
  message: 'Unable to connect. Please try again.',
  onRetry: () {
    // Retry the operation
  },
  onDismiss: () {
    // Handle dismissal
  },
);

// Simple dialog (OK button only)
ErrorDialog.show(
  context,
  title: 'Error',
  message: 'Something went wrong.',
);
```

**Features:**
- Modal dialog that blocks interaction
- Error icon with colored background
- Optional retry and cancel buttons
- Rounded corners matching app design

### 3. InlineError

For form validation errors:

```dart
Column(
  children: [
    TextField(/* ... */),
    if (errorMessage != null)
      InlineError(message: errorMessage!),
  ],
)
```

**Features:**
- Displays below form fields
- Error icon with message
- Red color matching app theme
- Compact design

## Centralized Error Handler

The `ErrorHandler` class provides unified error handling:

### Basic Usage

```dart
ErrorHandler.handle(
  context,
  error,
  showDialog: false, // true for dialog, false for SnackBar
  onRetry: () {
    // Optional retry callback
  },
);
```

### Async Operation Handling

```dart
final success = await ErrorHandler.handleAsync(
  context,
  () async {
    // Your async operation
    await authProvider.signUp(email, password);
  },
  showDialog: true,
  onRetry: _handleSignUp,
  onSuccess: () {
    // Called on success
    context.go('/home');
  },
);
```

**Features:**
- Automatically catches and displays errors
- Maps exceptions to user-friendly messages
- Returns boolean indicating success/failure
- Supports retry callbacks

## Retry Logic

The `RetryHelper` class implements automatic retry for network operations:

### Exponential Backoff

```dart
final result = await RetryHelper.execute<String>(
  operation: () async {
    // Network operation that might fail
    return await apiClient.fetchData();
  },
  maxAttempts: 3,
  delayFactor: Duration(seconds: 1),
  // Delays: 1s, 2s, 3s between retries
);
```

### Fixed Delay

```dart
final result = await RetryHelper.executeWithFixedDelay<String>(
  operation: () async {
    return await apiClient.fetchData();
  },
  maxAttempts: 3,
  delay: Duration(seconds: 2),
  // Fixed 2s delay between retries
);
```

**Features:**
- Only retries on `NetworkException`
- Configurable retry attempts and delays
- Exponential or fixed backoff strategies
- Throws last exception after all attempts fail

## API Client with Retry

The `ApiClient` class wraps HTTP calls with automatic retry:

```dart
// GET request with retry
final response = await ApiClient.get('/api/activities');

// POST request with retry
final response = await ApiClient.post('/api/auth/login', {
  'email': email,
  'password': password,
});
```

**Features:**
- Automatic retry on network failures
- Configurable retry attempts
- Consistent error handling
- Ready for Dio integration

## Best Practices

### 1. Use Appropriate Exception Types

```dart
// Good
if (!isValidEmail(email)) {
  throw ValidationException('Invalid email format');
}

// Bad
if (!isValidEmail(email)) {
  throw Exception('Invalid email format');
}
```

### 2. Handle Errors at UI Layer

```dart
// Good - Let ErrorHandler manage UI feedback
await ErrorHandler.handleAsync(context, operation);

// Avoid - Manual error handling everywhere
try {
  await operation();
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(/* ... */);
}
```

### 3. Use Validators in Forms

```dart
// Good
TextFormField(
  validator: Validators.validateEmail,
)

// Avoid - Inline validation logic
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // ... more validation
  },
)
```

### 4. Provide Retry for Network Operations

```dart
// Good - Automatic retry
await RetryHelper.execute(
  operation: () => apiClient.fetchData(),
  maxAttempts: 3,
);

// Avoid - Single attempt only
await apiClient.fetchData();
```

### 5. Show Appropriate UI Feedback

```dart
// Critical errors - Use dialog
ErrorHandler.handle(context, error, showDialog: true);

// Non-critical errors - Use SnackBar
ErrorHandler.handle(context, error, showDialog: false);
```

## Error Messages

The error handler automatically maps exceptions to user-friendly messages:

| Exception Type | User Message |
|---------------|--------------|
| NetworkException | "Unable to connect to the server. Please check your internet connection and try again." |
| AuthException | Uses the exception's message |
| ValidationException | Uses the exception's message |
| Other | "An unexpected error occurred. Please try again later." |

## Testing Error Handling

### Unit Tests

```dart
test('validates email format', () {
  expect(Validators.validateEmail('invalid'), isNotNull);
  expect(Validators.validateEmail('valid@email.com'), isNull);
});
```

### Widget Tests

```dart
testWidgets('shows error dialog', (tester) async {
  await tester.pumpWidget(/* ... */);
  
  await ErrorDialog.show(
    context,
    title: 'Error',
    message: 'Test error',
  );
  
  await tester.pumpAndSettle();
  expect(find.text('Error'), findsOneWidget);
});
```

### Integration Tests

```dart
testWidgets('handles sign up error', (tester) async {
  // Trigger error
  await tester.tap(find.text('Sign Up'));
  await tester.pumpAndSettle();
  
  // Verify error is displayed
  expect(find.byType(SnackBar), findsOneWidget);
});
```

## Examples

See `lib/core/examples/error_handling_examples.dart` for complete working examples of:

1. Form validation
2. Error SnackBar usage
3. Error Dialog usage
4. Inline error display
5. Centralized error handler
6. Retry logic
7. Custom exception throwing
8. Complete form with error handling

## Future Enhancements

- Error logging service integration
- Analytics tracking for errors
- Offline error queue
- Custom error recovery strategies
- Localized error messages
