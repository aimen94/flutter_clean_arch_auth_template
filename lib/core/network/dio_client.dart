import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// HTTP client wrapper using Dio with enhanced logging and configuration
///
/// This class provides a configured HTTP client with:
/// - Custom timeout settings
/// - Request/response logging
/// - Status code validation
/// - Error handling
/// - Convenient HTTP method wrappers
///
/// The client is designed to work seamlessly with the API interceptors
/// for authentication and request/response processing.
class DioClient {
  /// Internal Dio instance with custom configuration
  final Dio _dio;

  /// Logger instance for request/response logging
  final Logger _logger;

  /// Public getter for accessing the configured Dio instance
  /// Used by interceptors and other services that need direct Dio access
  Dio get dio => _dio;

  /// Creates a configured DioClient with custom settings
  ///
  /// [dio] - Base Dio instance to configure
  /// [logger] - Logger for request/response logging
  DioClient(this._dio, this._logger) {
    _dio
      // Disable automatic redirects for better control
      ..options.followRedirects = false
      // Custom status code validation (accept all status codes < 500)
      ..options.validateStatus = (status) {
        return status != null && status < 500;
      }
      // Set connection timeout to 30 seconds
      ..options.connectTimeout = const Duration(seconds: 30)
      // Set receive timeout to 30 seconds
      ..options.receiveTimeout = const Duration(seconds: 30)
      // Set response type to JSON for automatic parsing
      ..options.responseType = ResponseType.json
      // Add built-in logging interceptor for debugging
      ..interceptors.add(
        LogInterceptor(
          requestBody: true, // Log request body
          responseBody: true, // Log response body
          logPrint: (object) => _logger.i(object.toString()),
        ),
      );
  }

  /// Performs an HTTP GET request with optional parameters
  ///
  /// [url] - The endpoint URL to request
  /// [queryParameters] - Optional query parameters for the request
  /// [options] - Optional request options and headers
  /// [cancelToken] - Optional token for cancelling the request
  /// [onReciveProgress] - Optional callback for download progress
  ///
  /// Returns a Future<Response> with the server response
  /// Throws DioException on network or server errors
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReciveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReciveProgress,
      );
      return response;
    } catch (e) {
      // Re-throw the exception to allow calling code to handle it
      rethrow;
    }
  }

  /// Performs an HTTP POST request with optional parameters
  ///
  /// [url] - The endpoint URL to request
  /// [data] - Optional request body data
  /// [queryParameters] - Optional query parameters for the request
  /// [options] - Optional request options and headers
  /// [cancelToken] - Optional token for cancelling the request
  /// [onSendProgress] - Optional callback for upload progress
  /// [onReciveProgress] - Optional callback for download progress
  ///
  /// Returns a Future<Response> with the server response
  /// Throws DioException on network or server errors
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReciveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReciveProgress,
      );
      return response;
    } catch (e) {
      // Re-throw the exception to allow calling code to handle it
      rethrow;
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReciveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReciveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}


// import 'package:dio/dio.dart';
// import 'package:logger/logger.dart';

// class DioClient {
//   final Dio _dio;
//   final Logger _logger;

//   DioClient({required String baseUrl})
//       : _dio = Dio(BaseOptions(baseUrl: baseUrl)),
//         _logger = Logger() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           _logger.i('Request: ${options.method} ${options.path}');
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           _logger.i('Response: ${response.statusCode} ${response.data}');
//           return handler.next(response);
//         },
//         onError: (DioException e, handler) {
//           _logger.e('Error: ${e.message}');
//           return handler.next(e);
//         },
//       ),
//     );
//   }

//   Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
//     return _dio.get(path, queryParameters: queryParameters);
//   }

//   Future<Response> post(String path,
//       {dynamic data, Map<String, dynamic>? queryParameters}) {
//     return _dio.post(path, data: data, queryParameters: queryParameters);
//   }

//   // Add other HTTP methods as needed
  
// }


