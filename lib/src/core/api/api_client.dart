import 'package:dio/dio.dart';

/// Custom exception for API related errors
class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// HTTP client for Radio Browser API
/// Handles all network requests with proper configuration
class ApiClient {
  /// Creates an [ApiClient] with a required [Dio] instance.
  ///
  /// The Dio instance should be provided via dependency injection
  /// (typically from dioProvider. This ensures a single HTTP client
  /// instance is used throughout the app for connection pooling and
  /// consistent configuration.
  ///
  /// Example:
  /// ```dart
  /// // Production use with provider:
  /// final dio = ref.watch(dioProvider);
  /// final client = ApiClient(dio: dio);
  ///
  /// // Testing with mock:
  /// final mockDio = MockDio();
  /// final client = ApiClient(dio: mockDio);
  /// ```
  ApiClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  /// Current Radio Browser API base URL
  /// Must be set via updateBaseUrl() after server discovery
  String? _baseUrl;

  /// Update the base URL (MUST be called after server discovery)
  void updateBaseUrl(String newBaseUrl) {
    _baseUrl = newBaseUrl;
    _dio.options.baseUrl = newBaseUrl;
  }

  /// Check if base URL has been set
  bool get isInitialized => _baseUrl != null && _baseUrl!.isNotEmpty;

  /// GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!isInitialized) {
      throw ApiException(
        'API client not initialized. Run server discovery first.',
      );
    }

    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!isInitialized) {
      throw ApiException(
        'API client not initialized. Run server discovery first.',
      );
    }

    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors and convert to user-friendly messages
  ApiException _handleError(DioException e) {
    String errorMessage;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          errorMessage = 'Resource not found.';
        } else if (statusCode == 500) {
          errorMessage = 'Server error. Please try again later.';
        } else {
          errorMessage = 'Request failed with status code: $statusCode';
        }
      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled.';
      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection.';
      case DioExceptionType.badCertificate:
        errorMessage = 'Bad certificate.';
      case DioExceptionType.unknown:
        errorMessage = 'An unexpected error occurred: ${e.message}';
    }
    return ApiException(errorMessage);
  }
}
