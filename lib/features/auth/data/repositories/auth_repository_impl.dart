import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/exceptions.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/core/network/network_info.dart';
import 'package:flutter_application_2/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_2/features/auth/data/models/request/login_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/request/register_request_model.dart';
import 'package:flutter_application_2/features/auth/data/models/request/update_user_request_model.dart';
import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domin/repository/auth_repository.dart';

/// Implementation of AuthRepository interface
///
/// This class implements the authentication repository pattern,
/// coordinating between remote and local data sources to provide
/// a unified interface for authentication operations.
///
/// Handles:
/// - Network connectivity checking before API calls
/// - Data synchronization between remote and local storage
/// - Error handling and failure mapping
/// - Business logic coordination for authentication flows
class AuthRepositoryImpl implements AuthRepository {
  /// Remote data source for API communication
  final AuthRemoteDataSource remoteDataSource;

  /// Network information service for connectivity checking
  final NetworkInfo networkInfo;

  /// Local data source for offline data access
  final AuthLocalDataSource localDataSource;

  /// Creates an AuthRepositoryImpl with required dependencies
  ///
  /// [remoteDataSource] - Service for API communication
  /// [networkInfo] - Service for network connectivity checking
  /// [localDataSource] - Service for local data storage
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  /// Authenticates a user with username and password
  ///
  /// [username] - User's username or email
  /// [password] - User's password
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity on successful authentication
  /// - Left: Failures on authentication failure
  ///
  /// The method:
  /// 1. Checks network connectivity
  /// 2. Makes API call to authenticate user
  /// 3. Caches authentication tokens and user data locally
  /// 4. Returns user entity or failure
  Future<Either<Failures, UserEntity>> login(
    String username,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        // Create login request model
        final loginRequest = LoginRequestModel(
          username: username,
          password: password,
        );

        // Authenticate user via API
        final loginResponseModel = await remoteDataSource.login(loginRequest);

        // Cache authentication tokens securely
        await localDataSource.cacheToken(
          accessToken: loginResponseModel.accessToken,
          refreshToken: loginResponseModel.refreshToken,
        );

        // Cache user profile data locally
        await localDataSource.cacheUser(loginResponseModel);

        return Right(loginResponseModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CashFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: "no internet connection"));
    }
  }

  @override
  /// Registers a new user account
  ///
  /// [username] - Unique username for the account
  /// [email] - Valid email address for the account
  /// [firstName] - User's first name
  /// [lastName] - User's last name
  /// [age] - User's age
  /// [password] - Secure password for account access
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity for newly created account
  /// - Left: Failures on registration failure
  ///
  /// The method:
  /// 1. Checks network connectivity
  /// 2. Makes API call to create user account
  /// 3. Returns user entity or failure
  Future<Either<Failures, UserEntity>> register({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required int age,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Create registration request model
        final registerRequest = RegisterRequestModel(
          username: username,
          email: email,
          firstName: firstName,
          lastName: lastName,
          age: age,
          password: password,
        );

        // Register user via API
        final userModel = await remoteDataSource.register(registerRequest);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }

  @override
  /// Logs out the current user
  ///
  /// Returns Either<Failures, void>:
  /// - Right: null on successful logout
  /// - Left: Failures on logout failure
  ///
  /// The method:
  /// 1. Clears all authentication tokens from secure storage
  /// 2. Clears cached user profile data
  /// 3. Returns success or failure
  Future<Either<Failures, void>> logout() async {
    try {
      await localDataSource.clearToken();
      await localDataSource.clearUser();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CashFailure(message: e.message));
    }
  }

  @override
  /// Retrieves the current user's profile information
  ///
  /// Returns Either<Failures, UserEntity>:
  /// - Right: UserEntity with profile data
  /// - Left: Failures on retrieval failure
  ///
  /// The method implements offline-first strategy:
  /// 1. Checks network connectivity
  /// 2. If online: fetches fresh data from API and caches it
  /// 3. If offline: returns cached user data if available
  /// 4. Returns user entity or failure
  Future<Either<Failures, UserEntity>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        // Fetch fresh user profile from API
        final userModel = await remoteDataSource.getProfile();

        // Cache the fresh data locally
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      try {
        // Try to get cached user data for offline access
        final user = await localDataSource.getCachedUser();
        if (user != null) {
          return Right(user);
        } else {
          return Left(
            CashFailure(message: "No internet connection and no cached user"),
          );
        }
      } on CacheException catch (e) {
        return Left(CashFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failures, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final cashUser = await localDataSource.getCachedUser();
        if (cashUser == null) {
          return Left(CashFailure(message: "No  cached user find for update"));
        }
        final updateUserRequest = UpdateUserRequestModel(
          firstName: firstName,
          lastName: lastName,
        );
        final updauserModel = await remoteDataSource.updateProfile(
          updateUserRequest: updateUserRequest,
          userId: cashUser.id.toString(),
        );
        await localDataSource.cacheUser(updauserModel);
        return Right(updauserModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CashFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: "No internet connection"));
    }
  }
}
