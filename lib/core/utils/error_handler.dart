import 'package:flutter/material.dart';
import '../exceptions/app_exception.dart';
import '../widgets/error_dialog.dart';
import '../widgets/error_snackbar.dart';

/// Centralized error handler for the application
class ErrorHandler {
  /// Handles an exception and displays appropriate UI feedback
  /// 
  /// [context] - BuildContext for showing UI elements
  /// [error] - The exception to handle
  /// [showDialog] - Whether to show a dialog (default: false, shows SnackBar)
  /// [onRetry] - Optional callback for retry action
  static void handle(
    BuildContext context,
    dynamic error, {
    bool showDialog = false,
    VoidCallback? onRetry,
  }) {
    final errorMessage = _getErrorMessage(error);
    final errorTitle = _getErrorTitle(error);

    if (showDialog) {
      ErrorDialog.show(
        context,
        title: errorTitle,
        message: errorMessage,
        onRetry: onRetry,
      );
    } else {
      ErrorSnackBar.show(context, errorMessage);
    }
  }

  /// Gets a user-friendly error message from an exception
  static String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    } else if (error is AuthException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is AppException) {
      return error.message;
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  /// Gets an appropriate error title based on the exception type
  static String _getErrorTitle(dynamic error) {
    if (error is NetworkException) {
      return 'Connection Error';
    } else if (error is AuthException) {
      return 'Authentication Error';
    } else if (error is ValidationException) {
      return 'Validation Error';
    } else {
      return 'Error';
    }
  }

  /// Handles errors in async operations with automatic UI feedback
  /// 
  /// Returns true if operation succeeded, false if it failed
  static Future<bool> handleAsync(
    BuildContext context,
    Future<void> Function() operation, {
    bool showDialog = false,
    VoidCallback? onRetry,
    VoidCallback? onSuccess,
  }) async {
    try {
      await operation();
      onSuccess?.call();
      return true;
    } catch (error) {
      handle(
        context,
        error,
        showDialog: showDialog,
        onRetry: onRetry,
      );
      return false;
    }
  }

  // Private constructor to prevent instantiation
  ErrorHandler._();
}
