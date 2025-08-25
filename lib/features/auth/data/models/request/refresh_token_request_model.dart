/// Data model for token refresh requests
///
/// This class represents the data structure required for refreshing
/// expired access tokens using a valid refresh token.
///
/// The model provides JSON serialization for HTTP request transmission
/// to the token refresh endpoint.
class RefreshTokenRequestModel {
  /// Valid refresh token used to obtain new access token
  final String refreshToken;

  /// Creates a RefreshTokenRequestModel with the refresh token
  ///
  /// [refreshToken] - Valid refresh token for token renewal
  RefreshTokenRequestModel({required this.refreshToken});

  /// Converts the model to JSON format for HTTP transmission
  ///
  /// Returns a Map containing the refresh token field
  /// Used when sending refresh token data to the authentication server
  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}
