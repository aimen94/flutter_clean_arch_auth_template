import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domin/repository/auth_repository.dart';

/// Use case for user registration operations
///
/// This class implements the registration use case following Clean Architecture
/// principles. It encapsulates the business logic for user account creation
/// and acts as an intermediary between the presentation layer and
/// the authentication repository.
///
/// The use case pattern ensures that business logic is centralized,
/// testable, and reusable across different parts of the application.
class RegisterUsecase {
  /// Authentication repository for registration operations
  final AuthRepository authRepository;

  /// Creates a RegisterUsecase with required repository
  ///
  /// [authRepository] - Repository for authentication operations
  RegisterUsecase(this.authRepository);

  /// Executes the registration use case
  ///
  /// [registerParams] - User registration data and parameters
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity for the newly created account
  /// - Left: Failures on registration failure
  ///
  /// This method:
  /// 1. Receives registration parameters from the presentation layer
  /// 2. Delegates account creation to the repository layer
  /// 3. Returns the result to the presentation layer
  /// 4. Handles both success and failure cases
  Future<Either<Failures, UserEntity>> call(RegisterParams registerParams) {
    return authRepository.register(
      username: registerParams.username,
      email: registerParams.email,
      firstName: registerParams.firstName,
      lastName: registerParams.lastName,
      age: registerParams.age,
      password: registerParams.password,
    );
  }
}

/// Data class containing registration parameters
///
/// This class encapsulates all the data needed for user registration.
/// It provides a clean, structured way to pass registration information
/// between different layers of the application.
///
/// Using a dedicated parameter class makes the use case more
/// maintainable and easier to extend in the future.
class RegisterParams {
  /// User's unique username for account identification
  final String username;

  /// User's email address for account verification
  final String email;

  /// User's first name for personal identification
  final String firstName;

  /// User's last name for personal identification
  final String lastName;

  /// User's age for account validation
  final int age;

  /// Secure password for account access
  final String password;

  /// Creates RegisterParams with all required registration data
  ///
  /// [username] - Unique username for the new account
  /// [email] - Valid email address for account verification
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [age] - User's age (must be positive integer)
  /// [password] - Secure password for account access
  RegisterParams({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.password,
  });
}
