import 'dart:async';
import '../exceptions/app_exception.dart';

/// Helper class for implementing retry logic for network operations
class RetryHelper {
  /// Executes a function with retry logic
  /// 
  /// [operation] - The async operation to execute
  /// [maxAttempts] - Maximum number of retry attempts (default: 3)
  /// [delayFactor] - Delay multiplier for exponential backoff (default: 1 second)
  /// [shouldRetry] - Optional function to determine if retry should occur
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration delayFactor = const Duration(seconds: 1),
    bool Function(Exception)? shouldRetry,
  }) async {
    int attempt = 0;
    Exception? lastException;

    while (attempt < maxAttempts) {
      try {
        return await operation();
      } on NetworkException catch (e) {
        lastException = e;
        attempt++;

        // Check if we should retry
        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        // Don't delay after the last attempt
        if (attempt >= maxAttempts) {
          break;
        }

        // Exponential backoff: delay increases with each attempt
        final delay = delayFactor * attempt;
        await Future.delayed(delay);
      } catch (e) {
        // For non-network exceptions, don't retry
        rethrow;
      }
    }

    // If we've exhausted all attempts, throw the last exception
    throw lastException ?? NetworkException('Operation failed after $maxAttempts attempts');
  }

  /// Executes a function with simple retry logic (fixed delay)
  /// 
  /// [operation] - The async operation to execute
  /// [maxAttempts] - Maximum number of retry attempts (default: 3)
  /// [delay] - Fixed delay between retries (default: 2 seconds)
  static Future<T> executeWithFixedDelay<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    Exception? lastException;

    while (attempt < maxAttempts) {
      try {
        return await operation();
      } on NetworkException catch (e) {
        lastException = e;
        attempt++;

        // Don't delay after the last attempt
        if (attempt >= maxAttempts) {
          break;
        }

        await Future.delayed(delay);
      } catch (e) {
        // For non-network exceptions, don't retry
        rethrow;
      }
    }

    // If we've exhausted all attempts, throw the last exception
    throw lastException ?? NetworkException('Operation failed after $maxAttempts attempts');
  }

  // Private constructor to prevent instantiation
  RetryHelper._();
}
