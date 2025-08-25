import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';

/// Use case for user logout operations
///
/// This class implements the logout use case following Clean Architecture
/// principles. It encapsulates the business logic for user logout
/// and acts as an intermediary between the presentation layer and
/// the authentication repository.
///
/// The use case pattern ensures that business logic is centralized,
/// testable, and reusable across different parts of the application.
class LogoutUsecase {
  /// Authentication repository for logout operations
  ///
  /// Note: There's a syntax error in this field declaration
  /// It should be: final AuthRepository authRepository;
  final AuthRepository;

  /// Creates a LogoutUsecase with required repository
  ///
  /// [AuthRepository] - Repository for authentication operations
  /// Note: Parameter name should match the field name
  LogoutUsecase(this.AuthRepository);

  /// Executes the logout use case
  ///
  /// Returns Either<Failures, void>:
  /// - Right: null on successful logout
  /// - Left: Failures on logout failure
  ///
  /// This method:
  /// 1. Delegates logout operation to the repository layer
  /// 2. Handles both success and failure cases
  /// 3. Returns the result to the presentation layer
  ///
  /// Note: There's a syntax error in the method call
  /// It should be: return authRepository.logout();
  Future<Either<Failures, void>> call() => AuthRepository.logout();
}
