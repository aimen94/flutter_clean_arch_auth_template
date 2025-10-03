import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';

/// Abstract interface for authentication repository operations
///
/// This interface defines the contract for authentication repositories
/// that coordinate between remote and local data sources to provide
/// a unified interface for authentication operations.
///
/// The repository pattern abstracts the data layer complexity and
/// provides a clean API for the business logic layer to interact
/// with authentication data.
///
/// All methods return Either<Failures, T> to handle both success
/// and failure cases in a functional programming style.
abstract class AuthRepository {
  /// Authenticates a user with username and password
  ///
  /// [username] - User's username or email for identification
  /// [password] - User's password for authentication verification
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity with profile data and authentication tokens
  /// - Left: Failures indicating the reason for authentication failure
  ///
  /// This method handles the complete login flow including:
  /// - Network connectivity checking
  /// - API authentication
  /// - Local token and user data caching
  Future<Either<Failures, UserEntity>> login(String username, String password);

  /// Registers a new user account
  ///
  /// [username] - Unique username for the new account
  /// [email] - Valid email address for account verification
  /// [firstName] - User's first name for personal identification
  /// [lastName] - User's last name for personal identification
  /// [age] - User's age for account validation
  /// [password] - Secure password for account access
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity for the newly created account
  /// - Left: Failures indicating the reason for registration failure
  ///
  /// This method handles user account creation including:
  /// - Network connectivity checking
  /// - API registration
  /// - Validation and error handling
  Future<Either<Failures, UserEntity>> register({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required int age,
    required String password,
  });

  /// Logs out the current user
  ///
  /// Returns Either<Failures, void>:
  /// - Right: null indicating successful logout
  /// - Left: Failures indicating the reason for logout failure
  ///
  /// This method handles the complete logout flow including:
  /// - Clearing authentication tokens from secure storage
  /// - Removing cached user profile data
  /// - Cleaning up local authentication state
  Future<Either<Failures, void>> logout();

  /// Retrieves the current user's profile information
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity with complete profile data
  /// - Left: Failures indicating the reason for retrieval failure
  ///
  /// This method implements an offline-first strategy:
  /// - Checks network connectivity first
  /// - If online: fetches fresh data from API and caches it
  /// - If offline: returns cached user data if available
  /// - Provides seamless user experience in both scenarios
  Future<Either<Failures, UserEntity>> getUserProfile();
  Future<Either<Failures, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
  });
}
