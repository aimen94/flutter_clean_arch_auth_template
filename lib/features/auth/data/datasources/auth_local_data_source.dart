import 'dart:convert';

import 'package:flutter_application_2/core/constants/storage_keys.dart';
import 'package:flutter_application_2/core/errors/exceptions.dart';
import 'package:flutter_application_2/core/storage/local_storage.dart';
import 'package:flutter_application_2/core/storage/secure_storage_manager.dart';
import 'package:flutter_application_2/features/auth/data/models/user_model.dart';

/// Abstract interface for local authentication data operations
///
/// This interface defines the contract for local authentication data sources
/// that handle storing and retrieving authentication-related data locally.
///
/// Provides methods for:
/// - Token management (access and refresh tokens)
/// - User data caching and retrieval
/// - Secure data operations using encrypted storage
/// - Data cleanup on logout or token expiration
abstract class AuthLocalDataSource {
  /// Stores authentication tokens securely
  ///
  /// [accessToken] - JWT access token for API authentication
  /// [refreshToken] - JWT refresh token for token renewal
  ///
  /// Tokens are stored in secure storage for security
  Future<void> cacheToken({
    required String accessToken,
    required String refreshToken,
  });

  /// Retrieves the current access token
  ///
  /// Returns the stored access token or null if not found
  /// Used for API authentication headers
  Future<String?> getAccessToken();

  /// Retrieves the current refresh token
  ///
  /// Returns the stored refresh token or null if not found
  /// Used for token refresh operations
  Future<String?> getRefrashToken();

  /// Clears all stored authentication tokens
  ///
  /// Removes access and refresh tokens from secure storage
  /// Called during logout or token expiration
  Future<void> clearToken();

  /// Stores user profile data locally
  ///
  /// [user] - UserModel containing profile information
  /// User data is stored in local storage for offline access
  Future<void> cacheUser(UserModel user);

  /// Retrieves cached user profile data
  ///
  /// Returns the stored user profile or null if not found
  /// Used for offline profile display
  Future<UserModel?> getCachedUser();

  /// Clears cached user profile data
  ///
  /// Removes user profile from local storage
  /// Called during logout or data cleanup
  Future<void> clearUser();
}

/// Implementation of AuthLocalDataSource interface
///
/// This class provides concrete implementation for local authentication
/// data operations using both secure and local storage.
///
/// Handles:
/// - Secure token storage using SecureStorageManager
/// - User profile caching using LocalStorage
/// - Proper error handling and exception management
/// - Data consistency between secure and local storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Secure storage manager for authentication tokens
  final SecureStorageManager _secureStorageManager;

  /// Local storage for user profile data
  final LocalStorage _localStorage;

  /// Creates an AuthLocalDataSourceImpl with required storage services
  ///
  /// [secureStorageManager] - Service for secure token storage
  /// [localStorage] - Service for local user data storage
  AuthLocalDataSourceImpl(this._secureStorageManager, this._localStorage);

  @override
  /// Stores authentication tokens in secure storage
  ///
  /// Both access and refresh tokens are stored securely
  /// Throws CacheException if storage operation fails
  Future<void> cacheToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _secureStorageManager.write(StorageKeys.accessToken, accessToken);
      await _secureStorageManager.write(StorageKeys.refreshToken, refreshToken);
    } catch (e) {
      throw CacheException('Failed to cache access token');
    }
  }

  @override
  /// Stores user profile data in local storage
  ///
  /// Converts UserModel to JSON and stores as string
  /// Used for offline profile access
  Future<void> cacheUser(UserModel user) async {
    final userMap = user.toJson();
    final userJsonString = json.encode(userMap);
    await _localStorage.setString('user', userJsonString);
  }

  @override
  /// Retrieves the current access token from secure storage
  ///
  /// Note: There's a bug in this implementation - it's reading
  /// the refresh token instead of the access token
  /// This should be corrected to read StorageKeys.accessToken
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorageManager.red(
        StorageKeys.refreshToken, // BUG: Should be StorageKeys.accessToken
      );
    } catch (e) {
      throw CacheException('Failed to read refresh token ');
    }
  }

  @override
  /// Retrieves cached user profile from local storage
  ///
  /// Decodes JSON string back to UserModel
  /// Returns null if no cached user data exists
  Future<UserModel?> getCachedUser() async {
    final userJSonString = _localStorage.getString(StorageKeys.userData);
    if (userJSonString != null) {
      final userMap = json.decode(userJSonString) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  @override
  /// Retrieves the current refresh token from secure storage
  ///
  /// Returns the stored refresh token or null if not found
  /// Used for token refresh operations
  Future<String?> getRefrashToken() async {
    try {
      return await _secureStorageManager.red(StorageKeys.refreshToken);
    } catch (e) {
      throw CacheException('Failed to read refresh token ');
    }
  }

  @override
  /// Clears all authentication tokens from secure storage
  ///
  /// Removes both access and refresh tokens
  /// Throws CacheException if deletion fails
  Future<void> clearToken() async {
    try {
      await _secureStorageManager.delete(StorageKeys.accessToken);
      await _secureStorageManager.delete(StorageKeys.refreshToken);
    } catch (e) {
      throw CacheException('field to delete token');
    }
  }

  @override
  /// Clears cached user profile from local storage
  ///
  /// Removes user data from local storage
  /// Throws CacheException if deletion fails
  Future<void> clearUser() async {
    try {
      await _localStorage.remove(StorageKeys.userData);
    } catch (e) {
      throw CacheException('field to delete user');
    }
  }
}
