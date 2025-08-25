import 'package:flutter_application_2/features/auth/data/models/user_model.dart';

/// Data model for successful login responses
///
/// This class extends UserModel to include authentication tokens
/// that are returned by the server after successful login.
///
/// Contains both user profile information and security tokens
/// needed for subsequent authenticated API requests.
///
/// The model provides JSON deserialization from server responses.
class LoginResponseModel extends UserModel {
  /// JWT access token for API authentication
  ///
  /// This token is used in the Authorization header for all
  /// authenticated API requests. It has a limited lifespan
  /// and must be refreshed when expired.
  final String accessToken;

  /// JWT refresh token for token renewal
  ///
  /// This token is used to obtain new access tokens when
  /// the current access token expires. It has a longer
  /// lifespan than the access token.
  final String refreshToken;

  /// Creates a LoginResponseModel with user data and authentication tokens
  ///
  /// [id] - Unique user identifier
  /// [username] - User's unique username
  /// [email] - User's email address
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [gender] - User's gender
  /// [image] - User's profile image URL
  /// [accessToken] - JWT access token for API authentication
  /// [refreshToken] - JWT refresh token for token renewal
  LoginResponseModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
    required this.accessToken,
    required this.refreshToken,
  });

  /// Creates a LoginResponseModel from JSON data
  ///
  /// [json] - Map containing user data and tokens from server response
  /// Returns a LoginResponseModel with all fields populated
  ///
  /// This factory method is used to deserialize server responses
  /// into a structured Dart object for easy access to user data and tokens.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
