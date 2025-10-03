import 'package:equatable/equatable.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';

/// Base class for all authentication states
///
/// This abstract class defines the contract for authentication states
/// and extends Equatable for value comparison. All authentication
/// states must extend this class to ensure proper state management.
///
/// The Equatable mixin enables automatic state comparison, which is
/// essential for efficient UI rebuilding in Flutter applications.
abstract class AuthState extends Equatable {
  /// Creates a base authentication state
  const AuthState();

  @override
  /// Defines the properties used for value equality comparison
  ///
  /// Returns a list of properties that determine state equality
  /// Used by Equatable for comparing AuthState instances
  List<Object> get props => [];
}

/// Initial authentication state
///
/// This state represents the default, uninitialized state of the
/// authentication system. It's typically emitted when the app starts
/// or when no authentication operation is in progress.
///
/// The UI should show the appropriate initial screen (login/register)
/// when this state is active.
class AuthInitial extends AuthState {}

/// Loading authentication state
///
/// This state indicates that an authentication operation is currently
/// in progress. It's emitted during login, registration, logout,
/// or profile retrieval operations.
///
/// The UI should show loading indicators (spinners, progress bars)
/// when this state is active to provide user feedback.
class AuthLoading extends AuthState {}

/// Successful authentication state
///
/// This state represents a successful authentication operation.
/// It contains the user entity with complete profile information
/// and is emitted after successful login, registration, or
/// profile retrieval.
///
/// The UI should navigate to the authenticated area and display
/// user information when this state is active.
class authSuccess extends AuthState {
  /// User entity containing profile information
  final UserEntity userEntity;

  /// Creates an AuthSuccess state with user data
  ///
  /// [userEntity] - Complete user profile information
  const authSuccess({required this.userEntity});

  @override
  /// Defines the properties used for value equality comparison
  ///
  /// Returns a list containing the user entity
  /// Used by Equatable for comparing AuthSuccess instances
  List<Object> get props => [userEntity];
}

/// Authentication error state
///
/// This state represents an authentication operation failure.
/// It contains an error message describing what went wrong
/// and is emitted when login, registration, logout, or profile
/// retrieval operations fail.
///
/// The UI should display error messages and provide recovery
/// options when this state is active.
class AuthErorr extends AuthState {
  /// Human-readable error message describing the failure
  final String errorMessage;

  /// Creates an AuthError state with error information
  ///
  /// [errorMessage] - Description of what went wrong
  const AuthErorr({required this.errorMessage});

  @override
  /// Defines the properties used for value equality comparison
  ///
  /// Returns a list containing the error message
  /// Used by Equatable for comparing AuthError instances
  List<Object> get props => [errorMessage];
}

/// Unauthenticated state
///
/// This state indicates that the user is not authenticated
/// and has no valid session. It's typically emitted after
/// successful logout or when authentication tokens expire.
///
/// The UI should redirect the user to the login screen
/// when this state is active.
class Unauthenticated extends AuthState {}
