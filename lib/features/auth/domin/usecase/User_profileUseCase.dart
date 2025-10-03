import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';

/// Use case for retrieving user profile information
///
/// This class implements the user profile retrieval use case following
/// Clean Architecture principles. It encapsulates the business logic
/// for fetching user profile data and acts as an intermediary between
/// the presentation layer and the authentication repository.
///
/// The use case pattern ensures that business logic is centralized,
/// testable, and reusable across different parts of the application.
///
/// This use case implements an offline-first strategy, providing
/// seamless user experience regardless of network connectivity.
class GetUserProfileUseCase {
  /// Authentication repository for profile operations
  final AuthRepository authRepository;

  /// Creates a GetUserProfileUseCase with required repository
  ///
  /// [authRepository] - Repository for authentication operations
  GetUserProfileUseCase(this.authRepository);

  /// Executes the user profile retrieval use case
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity with complete profile data
  /// - Left: Failures on profile retrieval failure
  ///
  /// This method:
  /// 1. Delegates profile retrieval to the repository layer
  /// 2. The repository implements offline-first strategy:
  ///    - If online: fetches fresh data from API and caches it
  ///    - If offline: returns cached user data if available
  /// 3. Returns the result to the presentation layer
  /// 4. Handles both success and failure cases
  ///
  /// The offline-first approach ensures users can access their
  /// profile information even without internet connectivity.
  Future<Either<Failures, UserEntity>> call() async {
    return await authRepository.getUserProfile();
  }
}
