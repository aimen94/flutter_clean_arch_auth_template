// lib/core/network/api_interceptors.dart

import 'package:dio/dio.dart';
import 'package:flutter_application_2/core/constants/api_endpoints.dart';
import 'package:flutter_application_2/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_2/features/auth/data/models/request/refresh_token_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/response/login_response_model.dart';
import 'package:logger/logger.dart';

/// API Interceptor that handles authentication and request/response logging
///
/// This interceptor provides the following functionality:
/// - Automatically adds authentication tokens to request headers
/// - Logs all requests and responses for debugging
/// - Handles token refresh on 401 Unauthorized responses
/// - Manages authentication state and user logout on token failure
///
/// The interceptor follows the Chain of Responsibility pattern,
/// allowing multiple interceptors to process requests in sequence.
class ApiInterceptors extends Interceptor {
  /// Logger instance for request/response logging
  final Logger _logger;

  /// Local data source for accessing stored authentication tokens
  final AuthLocalDataSource _localDataSource;

  /// Creates an API interceptor with logging and local data access
  ///
  /// [logger] - Logger instance for debugging and monitoring
  /// [localDataSource] - Data source for accessing stored tokens
  ApiInterceptors(this._logger, this._localDataSource);

  /// Intercepts outgoing requests before they are sent
  ///
  /// Automatically adds the current access token to the Authorization header
  /// if a valid token exists in local storage.
  ///
  /// [options] - Request configuration and headers
  /// [handler] - Handler to continue or modify the request
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Retrieve the current access token from secure storage
    final accessToken = await _localDataSource.getAccessToken();

    // Add Bearer token to Authorization header if token exists
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Log the request details for debugging and monitoring
    _logger.i(
      'REQUEST[${options.method}] => PATH: ${options.path} \nHEADERS: ${options.headers}',
    );

    // Allow the request to continue to the next interceptor or network
    super.onRequest(options, handler);
  }

  /// Intercepts incoming responses before they reach the application
  ///
  /// Logs response details for debugging and monitoring purposes.
  ///
  /// [response] - The HTTP response from the server
  /// [handler] - Handler to continue or modify the response
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response details including status code and data
    _logger.i(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} \nDATA: ${response.data}',
    );

    // Allow the response to continue to the application
    super.onResponse(response, handler);
  }

  /// Intercepts errors that occur during request/response processing
  ///
  /// Handles authentication errors (401) by attempting to refresh the token
  /// and retry the original request. If token refresh fails, it clears
  /// the user's authentication state and logs them out.
  ///
  /// [err] - The DioException that occurred
  /// [handler] - Handler to resolve, reject, or modify the error
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Log the error details for debugging
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\nMESSAGE: ${err.message}',
    );

    // Handle authentication errors (401 Unauthorized)
    if (err.response?.statusCode == 401) {
      try {
        // Attempt to refresh the access token using the refresh token
        final newToken = await _refreshToken();

        // Cache the new tokens in secure storage
        await _localDataSource.cacheToken(
          accessToken: newToken.accessToken,
          refreshToken: newToken.refreshToken,
        );

        _logger.i('Tokens refreshed and cached successfully.');

        // Update the original request with the new access token
        err.requestOptions.headers['Authorization'] =
            'Bearer ${newToken.accessToken}';

        // Retry the original request with the new token
        final dio = Dio();
        final response = await dio.fetch(err.requestOptions);

        // Resolve the error by returning the successful response
        return handler.resolve(response);
      } on DioException catch (e) {
        // If token refresh fails, log the error and clear user data
        _logger.e('Failed to refresh token: ${e.message}');
        await _localDataSource.clearToken();
        await _localDataSource.clearUser();

        // Reject the error to allow the application to handle the failure
        return handler.reject(err);
      }
    }

    // For non-authentication errors, allow the error to propagate
    super.onError(err, handler);
  }

  /// Refreshes the access token using the stored refresh token
  ///
  /// Makes a separate HTTP request to the token refresh endpoint
  /// to obtain new access and refresh tokens.
  ///
  /// Returns a [LoginResponseModel] containing the new tokens
  ///
  /// Throws [DioException] if no refresh token exists or the request fails
  Future<LoginResponseModel> _refreshToken() async {
    // Retrieve the refresh token from secure storage
    final refreshToken = await _localDataSource.getRefrashToken();

    // Validate that a refresh token exists
    if (refreshToken == null) {
      throw DioException(
        requestOptions: RequestOptions(),
        message: 'No refresh token found.',
      );
    }

    // Create a new Dio instance for the refresh token request
    // This avoids using the interceptor chain to prevent infinite loops
    final dio = Dio();

    // Make the refresh token request to the API
    final response = await dio.post(
      ApiEndpoints.refreshToken,
      data: RefreshTokenRequestModel(refreshToken: refreshToken).toJson(),
    );

    // Parse and return the new tokens
    return LoginResponseModel.fromJson(response.data);
  }
}
