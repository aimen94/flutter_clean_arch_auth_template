import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract interface for secure data storage operations
///
/// This interface defines the contract for secure storage services
/// that handle sensitive data using Flutter Secure Storage.
///
/// Provides methods for storing and retrieving encrypted data
/// including authentication tokens, passwords, and other sensitive information.
///
/// All data stored through this interface is encrypted and secure.
abstract class SecureStorageManager {
  /// Stores a string value securely with the specified key
  ///
  /// [key] - Unique identifier for the stored value
  /// [value] - Sensitive string data to encrypt and store
  ///
  /// The value is automatically encrypted before storage
  Future<void> write(String key, String value);

  /// Retrieves a securely stored string value by key
  ///
  /// [key] - Unique identifier for the stored value
  /// Returns the decrypted string or null if not found
  ///
  /// Note: There's a typo in the method name (red instead of read)
  /// This should be corrected in future versions
  Future<String?> red(String key);

  /// Removes a securely stored value by key
  ///
  /// [key] - Unique identifier for the value to remove
  /// Permanently deletes the encrypted data
  Future<void> delete(String key);

  /// Removes all securely stored data
  ///
  /// Clears all encrypted data from secure storage
  /// Use with caution as this action cannot be undone
  Future<void> deleteAll();
}

/// Implementation of SecureStorageManager interface using FlutterSecureStorage
///
/// This class provides concrete implementation for secure data storage
/// using the flutter_secure_storage package for encrypted data persistence.
///
/// Handles all secure storage operations with automatic encryption/decryption
/// and proper error handling for sensitive data operations.
class SecureStorageManagerImpl implements SecureStorageManager {
  /// FlutterSecureStorage instance for encrypted data storage
  final FlutterSecureStorage _storge;

  /// Creates a SecureStorageManagerImpl with the required secure storage instance
  ///
  /// [storge] - FlutterSecureStorage instance for encrypted data storage
  /// Note: There's a typo in the parameter name (storge instead of storage)
  SecureStorageManagerImpl(this._storge);

  @override
  /// Removes a securely stored value by key
  ///
  /// Permanently deletes the encrypted data associated with the specified key
  Future<void> delete(String key) async {
    await _storge.delete(key: key);
  }

  @override
  /// Removes all securely stored data
  ///
  /// Clears all encrypted data from secure storage
  /// This operation is irreversible and should be used carefully
  Future<void> deleteAll() async {
    await _storge.deleteAll();
  }

  @override
  /// Retrieves a securely stored string value by key
  ///
  /// Automatically decrypts the stored value before returning
  /// Returns null if the key doesn't exist or decryption fails
  ///
  /// Note: Method name has typo (red instead of read)
  Future<String?> red(String key) async {
    return await _storge.read(key: key);
  }

  @override
  /// Stores a string value securely with the specified key
  ///
  /// Automatically encrypts the value before storage
  /// The encrypted data is stored securely on the device
  Future<void> write(String key, String value) async {
    await _storge.write(key: key, value: value);
  }
}
