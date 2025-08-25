import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domin/repository/auth_repository.dart';

/// Use case for user authentication operations
///
/// This class implements the login use case following Clean Architecture
/// principles. It encapsulates the business logic for user authentication
/// and acts as an intermediary between the presentation layer and
/// the authentication repository.
///
/// The use case pattern ensures that business logic is centralized,
/// testable, and reusable across different parts of the application.
class LoginUsecase {
  /// Authentication repository for data operations
  final AuthRepository authRepository;

  /// Creates a LoginUsecase with required repository
  ///
  /// [authRepository] - Repository for authentication operations
  LoginUsecase(this.authRepository);

  /// Executes the login use case
  ///
  /// [loginParams] - Login credentials and parameters
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity on successful authentication
  /// - Left: Failures on authentication failure
  ///
  /// This method:
  /// 1. Receives login parameters from the presentation layer
  /// 2. Delegates authentication to the repository layer
  /// 3. Returns the result to the presentation layer
  /// 4. Handles both success and failure cases
  Future<Either<Failures, UserEntity>> call(LoginParams loginParams) async {
    return await authRepository.login(
      loginParams.username,
      loginParams.password,
    );
  }
}

/// Data class containing login parameters
///
/// This class encapsulates all the data needed for user authentication.
/// It provides a clean, structured way to pass login credentials
/// between different layers of the application.
///
/// Using a dedicated parameter class makes the use case more
/// maintainable and easier to extend in the future.
class LoginParams {
  /// User's username or email for identification
  final String username;

  /// User's password for authentication verification
  final String password;

  /// Creates LoginParams with required credentials
  ///
  /// [username] - User's username or email address
  /// [password] - User's password for authentication
  LoginParams({required this.username, required this.password});
}
