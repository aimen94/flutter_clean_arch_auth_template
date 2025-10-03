import 'package:dio/dio.dart';
import 'package:flutter_application_2/core/constants/api_endpoints.dart';
import 'package:flutter_application_2/core/errors/exceptions.dart';
import 'package:flutter_application_2/core/network/dio_client.dart';
import 'package:flutter_application_2/features/auth/data/models/request/login_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/request/refresh_token_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/request/register_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/request/update_user_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/response/login_response_model.dart';
import 'package:flutter_application_2/features/auth/data/models/user_model.dart';

/// Abstract interface for remote authentication data operations
///
/// This interface defines the contract for remote authentication data sources
/// that handle API calls to the authentication server.
///
/// Provides methods for:
/// - User authentication (login/register)
/// - Token refresh operations
/// - User profile retrieval
/// - Server communication using HTTP requests
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel loginRequest);

  Future<UserModel> register(RegisterRequestModel registerRequest);

  Future<UserModel> getProfile();

  Future<LoginResponseModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  );
  Future<UserModel> updateProfile({
    required UpdateUserRequestModel updateUserRequest,
    required String userId,
  });
}

/// Implementation of AuthRemoteDataSource interface
///
/// This class provides concrete implementation for remote authentication
/// data operations using DioClient for HTTP communication.
///
/// Handles:
/// - HTTP requests to authentication endpoints
/// - Response parsing and error handling
/// - Exception management for network failures
/// - Proper error messages for user feedback
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// HTTP client for making API requests
  DioClient _dioClient;

  /// Creates an AuthRemoteDataSourceImpl with required HTTP client
  ///
  /// [dioClient] - Configured HTTP client for API communication
  AuthRemoteDataSourceImpl(this._dioClient);

  Future<T> _handleApiRequest<T>({
    required Future<Response> Function() apiRequest,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await apiRequest();
      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data is Map
              ? response.data['message']
              : 'an Unknown server error ',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data is Map
            ? e.response?.data['message']
            : 'A Network error occurred',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(
        message: "an unexpected error occurred: $e",
        statusCode: 500,
      );
    }
  }

  @override
  /// Authenticates a user with username and password
  ///
  /// Makes POST request to login endpoint with credentials
  /// Returns user data and authentication tokens on success
  /// Throws ServerException with appropriate error message on failure
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    return _handleApiRequest<LoginResponseModel>(
      apiRequest: () =>
          _dioClient.post(ApiEndpoints.login, data: loginRequest.toJson()),
      fromJson: (json) => LoginResponseModel.fromJson(json),
    );
  }

  // Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
  //   try {
  //     final response = await _dioClient.post(
  //       ApiEndpoints.login,
  //       data: loginRequest.toJson(),
  //     );

  //     if (response.statusCode == 200) {
  //       return LoginResponseModel.fromJson(response.data);
  //     } else {
  //       // Extract error message from response data
  //       String errorMessage = 'Login failed';
  //       if (response.data is Map<String, dynamic>) {
  //         errorMessage = response.data['message'] ?? errorMessage;
  //       }

  //       throw ServerException(
  //         message: response.data['message'] ?? 'login Faild',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     // Handle Dio-specific errors (network, timeout, etc.)
  //     String errorMessage = e.message ?? 'An unknown error occurred';
  //     if (e.response?.data is Map<String, dynamic>) {
  //       errorMessage = e.response!.data['message'] ?? errorMessage;
  //     }

  //     throw ServerException(
  //       message: errorMessage,
  //       statusCode: e.response?.statusCode,
  //     );
  //   } catch (e) {
  //     // Handle any other unexpected errors
  //     throw ServerException(
  //       message: 'An unknown error occurred: $e',
  //       statusCode: 500,
  //     );
  //   }
  // }

  @override
  /// Registers a new user account
  ///
  /// Makes POST request to register endpoint with user data
  /// Returns user profile on successful registration
  /// Throws ServerException with appropriate error message on failure
  // Future<UserModel> register(RegisterRequestModel registerRequest) async {
  //   try {
  //     final response = await _dioClient.post(
  //       ApiEndpoints.register,
  //       data: registerRequest.toJson(),
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return UserModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         message: response.data['message'] ?? 'Register Faild',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw ServerException(
  //       message: e.message ?? 'ann erorr occurred: $e',
  //       statusCode: 500,
  //     );
  //   } catch (e) {
  //     throw ServerException(
  //       message: 'An unknown error occurred: $e',
  //       statusCode: 500,
  //     );
  //   }
  // }
  Future<UserModel> register(RegisterRequestModel registerRequest) async {
    return _handleApiRequest<UserModel>(
      apiRequest: () => _dioClient.post(
        ApiEndpoints.register,
        data: registerRequest.toJson(),
      ),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  /// Retrieves the current user's profile information
  ///
  /// Makes GET request to profile endpoint
  /// Returns complete user profile data
  /// Throws ServerException with appropriate error message on failure
  // Future<UserModel> getProfile() async {
  //   try {
  //     final response = await _dioClient.get(ApiEndpoints.getProfile);
  //     if (response.statusCode == 200) {
  //       return UserModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         message: response.data is Map
  //             ? response.data['message']
  //             : 'filed to get user data',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw ServerException(
  //       message: e.message ?? 'an erorr occurred: $e',
  //       statusCode: 500,
  //     );
  //   } catch (e) {
  //     throw ServerException(
  //       message: 'An unknown error occurred: $e',
  //       statusCode: 500,
  //     );
  //   }
  // }
  Future<UserModel> getProfile() async {
    return _handleApiRequest<UserModel>(
      apiRequest: () => _dioClient.get(ApiEndpoints.getProfile),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  @override
  /// Refreshes the access token using a refresh token
  ///
  /// Makes POST request to refresh token endpoint
  /// Returns new access and refresh tokens on success
  /// Throws ServerException with appropriate error message on failure
  // Future<LoginResponseModel> refreshToken(
  //   RefreshTokenRequestModel refreshTokenRequest,
  // ) async {
  //   try {
  //     final response = await _dioClient.post(
  //       ApiEndpoints.refreshToken,
  //       data: refreshTokenRequest.toJson(),
  //     );
  //     if (response.statusCode == 200) {
  //       return LoginResponseModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         message: response.data is Map
  //             ? response.data['message']
  //             : 'Field to  refrashe Token',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw ServerException(
  //       message: e.message ?? 'an erorr ouccred',
  //       statusCode: 500,
  //     );
  //   } catch (e) {
  //     throw ServerException(
  //       message: 'An unknown error occurred: $e',
  //       statusCode: 500,
  //     );
  //   }
  // }
  Future<LoginResponseModel> refreshToken(
    RefreshTokenRequestModel refreshTokenRequest,
  ) async {
    return _handleApiRequest<LoginResponseModel>(
      apiRequest: () => _dioClient.post(
        ApiEndpoints.refreshToken,
        data: refreshTokenRequest.toJson(),
      ),
      fromJson: (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<UserModel> updateProfile({
    required UpdateUserRequestModel updateUserRequest,
    required String userId,
  }) async {
    return _handleApiRequest<UserModel>(
      apiRequest: () => _dioClient.put(
        '${ApiEndpoints.updateProfile}$userId',
        data: updateUserRequest.toJson(),
      ),
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  // Future<UserModel> updateProfile({
  //   required UpdateUserRequestModel updateUserRequest,
  //   required String userId,
  // }) async {
  //   try {
  //     final response = await _dioClient.put(
  //       "${ApiEndpoints.updateProfile}$userId",
  //       data: updateUserRequest.toJson(),
  //     );
  //     if (response.statusCode == 200) {
  //       return UserModel.fromJson(response.data);
  //     } else {
  //       throw ServerException(
  //         message: response.data is Map
  //             ? response.data['message']
  //             : 'filed to get user data',
  //         statusCode: response.statusCode,
  //       );
  //     }
  //   } on DioException catch (e) {
  //     throw ServerException(
  //       message: e.message ?? 'An error occurred',
  //       statusCode: e.response?.statusCode,
  //     );
  //   } catch (e) {
  //     throw ServerException(
  //       message: 'An unknown error occurred: $e',
  //       statusCode: 500,
  //     );
  //   }
  // }
}
