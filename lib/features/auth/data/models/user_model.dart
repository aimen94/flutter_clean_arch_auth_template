import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';

/// Data model representing a user's profile information
///
/// This class extends UserEntity to provide data layer functionality
/// including JSON serialization and deserialization for API communication.
///
/// Contains all user profile fields that are stored and retrieved
/// from the authentication server and local storage.
///
/// The model serves as the bridge between the domain layer (UserEntity)
/// and the data layer (API responses, local storage).
class UserModel extends UserEntity {
  /// Creates a UserModel with all required user profile information
  ///
  /// [id] - Unique user identifier from the server
  /// [username] - User's unique username for login
  /// [email] - User's email address for communication
  /// [firstName] - User's first name for personal identification
  /// [lastName] - User's last name for personal identification
  /// [gender] - User's gender for personalization
  /// [image] - URL to user's profile image
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.image,
  });

  /// Creates a UserModel from JSON data
  ///
  /// [json] - Map containing user data from server response or local storage
  /// Returns a UserModel with all fields populated
  ///
  /// This factory method is used to deserialize JSON data into a
  /// structured Dart object for easy access to user profile information.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
    );
  }

  /// Converts the UserModel to JSON format
  ///
  /// Returns a Map containing all user profile fields
  /// Used for:
  /// - Storing user data in local storage
  /// - Sending user data to the server
  /// - Serializing user information for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
    };
  }
}
