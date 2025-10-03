import 'package:flutter_application_2/features/auth/domain/usecase/UpdateUserUseCase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/User_profileUseCase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/login_usecase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/logout_usecase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/register_usecase.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Authentication Cubit for state management
///
/// This class manages the authentication state using the Cubit pattern
/// from the flutter_bloc package. It coordinates between the UI layer
/// and the business logic layer (use cases) to handle all authentication
/// operations.
///
/// The Cubit provides a simple, lightweight alternative to Bloc
/// by eliminating the need for events and focusing on method calls
/// that directly emit new states.
///
/// Features:
/// - User login and registration
/// - User logout and session management
/// - User profile retrieval
/// - State management for loading, success, and error states
class AuthCubit extends Cubit<AuthState> {
  /// Use case for user authentication operations
  final LoginUsecase loginUsecase;

  /// Use case for user registration operations
  final RegisterUsecase registerUsecase;

  /// Use case for user logout operations
  final LogoutUsecase logoutUsecase;

  /// Use case for retrieving user profile information
  final GetUserProfileUseCase getUserProfileUseCase;
  final Updateuserusecase updateuserusecase;

  /// Creates an AuthCubit with required use cases
  ///
  /// [logoutUsecase] - Use case for logout operations
  /// [loginUsecase] - Use case for login operations
  /// [registerUsecase] - Use case for registration operations
  /// [getUserProfileUseCase] - Use case for profile retrieval
  AuthCubit({
    required this.logoutUsecase,
    required this.loginUsecase,
    required this.registerUsecase,
    required this.getUserProfileUseCase,
    required this.updateuserusecase,
  }) : super(AuthInitial());

  /// Authenticates a user with username and password
  ///
  /// [username] - User's username or email
  /// [password] - User's password
  ///
  /// This method:
  /// 1. Emits AuthLoading state to show loading UI
  /// 2. Executes login use case with provided credentials
  /// 3. Emits appropriate state based on result:
  ///    - AuthSuccess with user data on successful login
  ///    - AuthError with error message on login failure
  ///
  /// The UI automatically responds to state changes to show
  /// appropriate feedback to the user.
  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    final params = LoginParams(username: username, password: password);
    final result = await loginUsecase.call(params);
    result.fold(
      (fialure) => emit(AuthErorr(errorMessage: fialure.message)),
      (user) => emit(authSuccess(userEntity: user)),
    );
  }

  /// Registers a new user account
  ///
  /// [registerParams] - Complete user registration data
  ///
  /// This method:
  /// 1. Emits AuthLoading state to show loading UI
  /// 2. Executes registration use case with provided data
  /// 3. Emits appropriate state based on result:
  ///    - AuthSuccess with user data on successful registration
  ///    - AuthError with error message on registration failure
  ///
  /// The UI automatically responds to state changes to show
  /// appropriate feedback to the user.
  Future<void> register(RegisterParams registerParams) async {
    emit(AuthLoading());
    final result = await registerUsecase.call(registerParams);
    result.fold(
      (fialure) => emit(AuthErorr(errorMessage: fialure.message)),
      (user) => emit(authSuccess(userEntity: user)),
    );
  }

  /// Logs out the current user
  ///
  /// This method:
  /// 1. Emits AuthLoading state to show loading UI
  /// 2. Executes logout use case to clear user session
  /// 3. Emits appropriate state based on result:
  ///    - Unauthenticated on successful logout
  ///    - AuthError with error message on logout failure
  ///
  /// The UI automatically responds to state changes to redirect
  /// the user to the login screen on successful logout.
  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUsecase.call();
    result.fold(
      (failure) => emit(AuthErorr(errorMessage: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  /// Retrieves the current user's profile information
  ///
  /// This method:
  /// 1. Emits AuthLoading state to show loading UI
  /// 2. Executes profile retrieval use case
  /// 3. Emits appropriate state based on result:
  ///    - AuthSuccess with user profile data on successful retrieval
  ///    - AuthError with error message on retrieval failure
  ///
  /// The profile retrieval implements offline-first strategy,
  /// providing seamless user experience regardless of network connectivity.
  Future<void> getUserProfile() async {
    emit(AuthLoading());
    final result = await getUserProfileUseCase.call();
    result.fold(
      (faliure) => emit(AuthErorr(errorMessage: faliure.message)),
      (user) => emit(authSuccess(userEntity: user)),
    );
  }

  Future<void> updateProfile(String firstName, String lastName) async {
    emit(AuthLoading());
    final parms = UpdateParams(firstName: firstName, lastName: lastName);
    final result = await updateuserusecase.call(parms);
    result.fold(
      (faliure) => emit(AuthErorr(errorMessage: faliure.message)),
      (user) => emit(authSuccess(userEntity: user)),
    );
  }
}
