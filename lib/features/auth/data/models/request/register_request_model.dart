/// Data model for user registration requests
///
/// This class represents the complete data structure required for
/// creating a new user account during registration.
///
/// Contains all necessary user information including personal details
/// and authentication credentials.
///
/// The model provides JSON serialization for HTTP request transmission.
class RegisterRequestModel {
  /// User's unique username for account identification
  final String username;

  /// User's email address for account verification and communication
  final String email;

  /// User's first name for personal identification
  final String firstName;

  /// User's last name for personal identification
  final String lastName;

  /// User's age for account validation and personalization
  final int age;

  /// User's password for account security and authentication
  final String password;

  /// Creates a RegisterRequestModel with all required user information
  ///
  /// [username] - Unique username for the account
  /// [email] - Valid email address for the account
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [age] - User's age (must be positive integer)
  /// [password] - Secure password for account access
  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.password,
  });

  /// Converts the model to JSON format for HTTP transmission
  ///
  /// Returns a Map containing all user registration fields
  /// Used when sending registration data to the authentication server
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'password': password,
    };
  }
}
