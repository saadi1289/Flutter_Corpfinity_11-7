import 'package:flutter/material.dart';
import '../exceptions/app_exception.dart';
import '../utils/error_handler.dart';
import '../utils/retry_helper.dart';
import '../utils/validators.dart';
import '../widgets/error_dialog.dart';
import '../widgets/error_snackbar.dart';
import '../widgets/inline_error.dart';

/// Examples demonstrating error handling patterns in the app
/// 
/// This file shows how to use:
/// - Exception hierarchy
/// - Form validators
/// - Error UI components (SnackBar, Dialog, InlineError)
/// - Retry logic for network operations
/// - Centralized error handler

// ============================================================================
// EXAMPLE 1: Using Form Validators
// ============================================================================

class FormValidationExample extends StatefulWidget {
  const FormValidationExample({super.key});

  @override
  State<FormValidationExample> createState() => _FormValidationExampleState();
}

class _FormValidationExampleState extends State<FormValidationExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with submission
      ErrorSnackBar.showSuccess(context, 'Form submitted successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field with validation
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),

          // Password field with validation
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 2: Using Error SnackBar
// ============================================================================

class SnackBarExample extends StatelessWidget {
  const SnackBarExample({super.key});

  void _showErrorSnackBar(BuildContext context) {
    ErrorSnackBar.show(
      context,
      'Unable to connect to the server. Please check your internet connection.',
    );
  }

  void _showSuccessSnackBar(BuildContext context) {
    ErrorSnackBar.showSuccess(
      context,
      'Activity completed successfully!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showErrorSnackBar(context),
          child: const Text('Show Error SnackBar'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showSuccessSnackBar(context),
          child: const Text('Show Success SnackBar'),
        ),
      ],
    );
  }
}

// ============================================================================
// EXAMPLE 3: Using Error Dialog
// ============================================================================

class ErrorDialogExample extends StatelessWidget {
  const ErrorDialogExample({super.key});

  void _showErrorDialog(BuildContext context) {
    ErrorDialog.show(
      context,
      title: 'Connection Error',
      message: 'Unable to connect to the server. Please check your internet connection and try again.',
      onRetry: () {
        // Retry the failed operation
        print('Retrying operation...');
      },
      onDismiss: () {
        // Handle dismissal
        print('Dialog dismissed');
      },
    );
  }

  void _showSimpleErrorDialog(BuildContext context) {
    ErrorDialog.show(
      context,
      title: 'Error',
      message: 'Something went wrong. Please try again later.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _showErrorDialog(context),
          child: const Text('Show Error Dialog with Retry'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showSimpleErrorDialog(context),
          child: const Text('Show Simple Error Dialog'),
        ),
      ],
    );
  }
}

// ============================================================================
// EXAMPLE 4: Using Inline Error
// ============================================================================

class InlineErrorExample extends StatefulWidget {
  const InlineErrorExample({super.key});

  @override
  State<InlineErrorExample> createState() => _InlineErrorExampleState();
}

class _InlineErrorExampleState extends State<InlineErrorExample> {
  String? _errorMessage;

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'This field is required';
      } else if (value.length < 3) {
        _errorMessage = 'Must be at least 3 characters';
      } else {
        _errorMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
          onChanged: _validateInput,
        ),
        if (_errorMessage != null)
          InlineError(message: _errorMessage!),
      ],
    );
  }
}

// ============================================================================
// EXAMPLE 5: Using Centralized Error Handler
// ============================================================================

class ErrorHandlerExample extends StatelessWidget {
  const ErrorHandlerExample({super.key});

  Future<void> _performNetworkOperation() async {
    // Simulate a network operation that might fail
    await Future.delayed(const Duration(seconds: 1));
    throw NetworkException('Failed to fetch data from server');
  }

  Future<void> _performAuthOperation() async {
    // Simulate an auth operation that might fail
    await Future.delayed(const Duration(seconds: 1));
    throw AuthException('Invalid credentials');
  }

  void _handleWithSnackBar(BuildContext context) async {
    await ErrorHandler.handleAsync(
      context,
      _performNetworkOperation,
      onSuccess: () {
        ErrorSnackBar.showSuccess(context, 'Operation completed!');
      },
    );
  }

  void _handleWithDialog(BuildContext context) async {
    await ErrorHandler.handleAsync(
      context,
      _performAuthOperation,
      showDialog: true,
      onRetry: () {
        print('Retrying authentication...');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _handleWithSnackBar(context),
          child: const Text('Network Error (SnackBar)'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _handleWithDialog(context),
          child: const Text('Auth Error (Dialog)'),
        ),
      ],
    );
  }
}

// ============================================================================
// EXAMPLE 6: Using Retry Helper
// ============================================================================

class RetryHelperExample extends StatelessWidget {
  const RetryHelperExample({super.key});

  Future<String> _fetchDataWithRetry() async {
    return await RetryHelper.execute<String>(
      operation: () async {
        // Simulate network call that might fail
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Simulate random failures
        // if (Random().nextBool()) {
        //   throw NetworkException('Connection timeout');
        // }
        
        return 'Data fetched successfully';
      },
      maxAttempts: 3,
      delayFactor: const Duration(seconds: 1),
    );
  }

  Future<void> _handleFetchWithRetry(BuildContext context) async {
    try {
      final result = await _fetchDataWithRetry();
      ErrorSnackBar.showSuccess(context, result);
    } catch (e) {
      ErrorHandler.handle(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleFetchWithRetry(context),
      child: const Text('Fetch Data with Retry'),
    );
  }
}

// ============================================================================
// EXAMPLE 7: Throwing Custom Exceptions
// ============================================================================

class CustomExceptionExample {
  Future<void> performOperation() async {
    try {
      // Some operation that might fail
      final isValid = false;
      
      if (!isValid) {
        throw ValidationException('Invalid input data');
      }
      
      // Network operation
      final hasConnection = false;
      if (!hasConnection) {
        throw NetworkException('No internet connection');
      }
      
      // Auth operation
      final isAuthenticated = false;
      if (!isAuthenticated) {
        throw AuthException('User not authenticated');
      }
      
    } on ValidationException catch (e) {
      print('Validation error: ${e.message}');
      rethrow;
    } on NetworkException catch (e) {
      print('Network error: ${e.message}');
      rethrow;
    } on AuthException catch (e) {
      print('Auth error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unknown error: $e');
      throw UnknownException('An unexpected error occurred');
    }
  }
}

// ============================================================================
// EXAMPLE 8: Complete Form with Error Handling
// ============================================================================

class CompleteFormExample extends StatefulWidget {
  const CompleteFormExample({super.key});

  @override
  State<CompleteFormExample> createState() => _CompleteFormExampleState();
}

class _CompleteFormExampleState extends State<CompleteFormExample> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _simulateSignUp() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate random failure
    // if (Random().nextBool()) {
    //   throw NetworkException('Failed to create account');
    // }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final success = await ErrorHandler.handleAsync(
      context,
      _simulateSignUp,
      showDialog: true,
      onRetry: _handleSubmit,
      onSuccess: () {
        ErrorSnackBar.showSuccess(context, 'Account created successfully!');
      },
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validators.validateEmail,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: Validators.validatePassword,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
