/// Data model for user login requests
///
/// This class represents the data structure required for user authentication.
/// Contains the minimum required credentials (username and password)
/// that are sent to the authentication server during login.
///
/// The model provides JSON serialization for HTTP request transmission.
class LoginRequestModel {
  /// User's unique username or email for identification
  final String username;

  /// User's password for authentication verification
  final String password;

  /// Creates a LoginRequestModel with required credentials
  ///
  /// [username] - User's username or email address
  /// [password] - User's password for authentication
  LoginRequestModel({required this.username, required this.password});

  /// Converts the model to JSON format for HTTP transmission
  ///
  /// Returns a Map containing username and password fields
  /// Used when sending login data to the authentication server
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
