import 'dart:async';
import '../exceptions/app_exception.dart';
import 'retry_helper.dart';

/// API client wrapper with built-in error handling and retry logic
/// 
/// This class demonstrates how to use the retry helper for network operations
class ApiClient {
  /// Makes a GET request with automatic retry on network errors
  /// 
  /// [endpoint] - The API endpoint to call
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// 
  /// Returns the response data on success
  /// Throws NetworkException on failure after all retries
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    int maxRetries = 3,
  }) async {
    return await RetryHelper.execute<Map<String, dynamic>>(
      operation: () async {
        try {
          // TODO: Replace with actual HTTP client call (e.g., Dio)
          // Example: final response = await dio.get(endpoint);
          
          // Simulate network call
          await Future.delayed(const Duration(milliseconds: 500));
          
          // Simulate random network failures for testing
          // if (Random().nextBool()) {
          //   throw NetworkException('Connection timeout');
          // }
          
          return {'success': true, 'data': {}};
        } catch (e) {
          if (e is NetworkException) rethrow;
          throw NetworkException('Failed to connect to server');
        }
      },
      maxAttempts: maxRetries,
      delayFactor: const Duration(seconds: 1),
    );
  }

  /// Makes a POST request with automatic retry on network errors
  /// 
  /// [endpoint] - The API endpoint to call
  /// [data] - The request body data
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// 
  /// Returns the response data on success
  /// Throws NetworkException on failure after all retries
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    int maxRetries = 3,
  }) async {
    return await RetryHelper.execute<Map<String, dynamic>>(
      operation: () async {
        try {
          // TODO: Replace with actual HTTP client call (e.g., Dio)
          // Example: final response = await dio.post(endpoint, data: data);
          
          // Simulate network call
          await Future.delayed(const Duration(milliseconds: 500));
          
          return {'success': true, 'data': {}};
        } catch (e) {
          if (e is NetworkException) rethrow;
          throw NetworkException('Failed to connect to server');
        }
      },
      maxAttempts: maxRetries,
      delayFactor: const Duration(seconds: 1),
    );
  }

  /// Makes a PUT request with automatic retry on network errors
  /// 
  /// [endpoint] - The API endpoint to call
  /// [data] - The request body data
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// 
  /// Returns the response data on success
  /// Throws NetworkException on failure after all retries
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    int maxRetries = 3,
  }) async {
    return await RetryHelper.execute<Map<String, dynamic>>(
      operation: () async {
        try {
          // TODO: Replace with actual HTTP client call (e.g., Dio)
          // Example: final response = await dio.put(endpoint, data: data);
          
          // Simulate network call
          await Future.delayed(const Duration(milliseconds: 500));
          
          return {'success': true, 'data': {}};
        } catch (e) {
          if (e is NetworkException) rethrow;
          throw NetworkException('Failed to connect to server');
        }
      },
      maxAttempts: maxRetries,
      delayFactor: const Duration(seconds: 1),
    );
  }

  /// Makes a DELETE request with automatic retry on network errors
  /// 
  /// [endpoint] - The API endpoint to call
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// 
  /// Returns the response data on success
  /// Throws NetworkException on failure after all retries
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    int maxRetries = 3,
  }) async {
    return await RetryHelper.execute<Map<String, dynamic>>(
      operation: () async {
        try {
          // TODO: Replace with actual HTTP client call (e.g., Dio)
          // Example: final response = await dio.delete(endpoint);
          
          // Simulate network call
          await Future.delayed(const Duration(milliseconds: 500));
          
          return {'success': true};
        } catch (e) {
          if (e is NetworkException) rethrow;
          throw NetworkException('Failed to connect to server');
        }
      },
      maxAttempts: maxRetries,
      delayFactor: const Duration(seconds: 1),
    );
  }

  // Private constructor to prevent instantiation
  ApiClient._();
}
