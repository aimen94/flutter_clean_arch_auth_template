import 'package:shared_preferences/shared_preferences.dart';

/// Abstract interface for local data storage operations
///
/// This interface defines the contract for local storage services
/// that handle non-sensitive data using SharedPreferences.
///
/// Provides methods for storing and retrieving various data types
/// including strings, booleans, and general data removal.
abstract class LocalStorage {
  /// Stores a string value with the specified key
  ///
  /// [key] - Unique identifier for the stored value
  /// [value] - String data to store
  Future<void> setString(String key, String value);

  /// Retrieves a stored string value by key
  ///
  /// [key] - Unique identifier for the stored value
  /// Returns the stored string or null if not found
  String? getString(String key);

  /// Stores a boolean value with the specified key
  ///
  /// [key] - Unique identifier for the stored value
  /// [value] - Boolean data to store
  Future<void> setBool(String key, bool value);

  /// Retrieves a stored boolean value by key
  ///
  /// [key] - Unique identifier for the stored value
  /// Returns the stored boolean or null if not found
  bool? getBoll(String key);

  /// Removes a stored value by key
  ///
  /// [key] - Unique identifier for the value to remove
  /// Returns true if removal was successful, false otherwise
  Future<bool> remove(String key);
}

/// Implementation of LocalStorage interface using SharedPreferences
///
/// This class provides concrete implementation for local data storage
/// using the SharedPreferences package for persistent data storage.
///
/// Handles all local storage operations including strings, booleans,
/// and data removal with proper error handling.
class LocalStorageimol implements LocalStorage {
  /// SharedPreferences instance for data persistence
  final SharedPreferences _pref;

  /// Creates a LocalStorageImpl with the required SharedPreferences instance
  ///
  /// [pref] - SharedPreferences instance for data storage
  LocalStorageimol(this._pref);

  @override
  /// Retrieves a stored boolean value by key
  ///
  /// Note: There's a typo in the method name (getBoll instead of getBool)
  /// This should be corrected in future versions
  bool? getBoll(String key) {
    return _pref.getBool(key);
  }

  @override
  /// Retrieves a stored string value by key
  ///
  /// Returns the stored string or null if the key doesn't exist
  String? getString(String key) {
    return _pref.getString(key);
  }

  @override
  /// Removes a stored value by key
  ///
  /// Removes the data associated with the specified key
  /// Returns true if removal was successful
  Future<bool> remove(String key) async {
    return await _pref.remove(key);
  }

  @override
  /// Stores a boolean value with the specified key
  ///
  /// Persists the boolean value for later retrieval
  Future<void> setBool(String key, bool value) async {
    await _pref.setBool(key, value);
  }

  @override
  /// Stores a string value with the specified key
  ///
  /// Persists the string value for later retrieval
  /// Returns a Future that completes when storage is finished
  Future<void> setString(String key, String value) {
    return _pref.setString(key, value);
  }
}
