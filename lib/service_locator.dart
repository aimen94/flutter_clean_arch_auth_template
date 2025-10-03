import 'package:dio/dio.dart';
import 'package:flutter_application_2/core/network/api_interceptors.dart';
import 'package:flutter_application_2/core/network/dio_client.dart';
import 'package:flutter_application_2/core/network/network_info.dart';
import 'package:flutter_application_2/core/storage/local_storage.dart';
import 'package:flutter_application_2/core/storage/secure_storage_manager.dart';
import 'package:flutter_application_2/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_2/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_2/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/UpdateUserUseCase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/User_profileUseCase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/login_usecase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/logout_usecase.dart';
import 'package:flutter_application_2/features/auth/domain/usecase/register_usecase.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_application_2/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_application_2/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_application_2/features/products/domain/repository/product_repository.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_all_categories_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_product_by_id_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_products_by_category_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_products_use_case.dart';
import 'package:flutter_application_2/features/products/domain/usecase/get_search_products_use_case.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/products/presentions/cubit/product_detail/product_detail_cubit.dart';

/// Global GetIt instance for dependency injection
/// Provides centralized access to all registered services
final sl = GetIt.instance;

/// Configures the dependency injection container
/// Registers all services, repositories, and use cases in the correct dependency order
///
/// Architecture follows Clean Architecture principles:
/// - External: Third-party services and platform APIs
/// - Core: Application-wide utilities and infrastructure
/// - Features: Business logic organized by domain
///
/// Dependencies are registered in order to avoid circular dependencies
Future<void> setupLocator() async {
  // =================== 1. External Dependencies ===================
  // Register platform and third-party services that don't depend on other services

  // SharedPreferences for local data storage
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio HTTP client for network requests
  sl.registerSingleton<Dio>(Dio());

  // Logger for application logging
  sl.registerSingleton<Logger>(Logger());

  // Secure storage for sensitive data (tokens, passwords)
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Internet connection checker for network status
  sl.registerSingleton<InternetConnection>(InternetConnection());

  // =================== 2. Core Infrastructure ===================
  // Register core services that provide application-wide functionality

  // Secure storage manager for handling sensitive data operations
  sl.registerLazySingleton<SecureStorageManager>(
    () => SecureStorageManagerImpl(sl.get<FlutterSecureStorage>()),
  );

  // Local storage for non-sensitive data
  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageimol(sl.get<SharedPreferences>()),
  );

  // Network information service for checking connectivity
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl.get<InternetConnection>()),
  );

  // ========================= 3. Features  ==============================
  // =================== 3.1 Features - Authentication ===================

  // Register authentication-related services following Clean Architecture

  // --- Data Sources Layer ---
  // Local data source for authentication data (tokens, user info)
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sl.get<SecureStorageManager>(),
      sl.get<LocalStorage>(),
    ),
  );
  ;

  // --- Core Network Services (after DataSources) ---
  // API interceptors for handling authentication headers and token refresh
  sl.registerLazySingleton<ApiInterceptors>(
    () => ApiInterceptors(sl.get<Logger>(), sl.get<AuthLocalDataSource>()),
  );

  // HTTP client with interceptors for authenticated requests
  sl.registerLazySingleton<DioClient>(
    () =>
        DioClient(sl.get<Dio>(), sl.get<Logger>())
          ..dio.interceptors.add(sl.get<ApiInterceptors>()),
  );

  // --- Remote Data Sources (after Core Services) ---
  // Remote data source for API calls
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl.get<DioClient>()),
  );
  // =================== 3.2 Features - Authentication ===================

  // products data sources are registered in product_service_locator.dart
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl.get<DioClient>()),
  );

  // --- Repository Layer ---
  // Repository implementation that coordinates between local and remote data sources
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl.get<AuthRemoteDataSource>(),
      localDataSource: sl.get<AuthLocalDataSource>(),
      networkInfo: sl.get<NetworkInfo>(),
    ),
  );
  //repository for products is registered in product_service_locator.dart
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      networkInfo: sl.get<NetworkInfo>(),
      remoteDataSource: sl.get<ProductRemoteDataSource>(),
    ),
  );

  // --- Use Cases Layer ---
  // Business logic operations for authentication
  sl.registerLazySingleton(() => LoginUsecase(sl.get<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUsecase(sl.get<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl.get<AuthRepository>()));
  sl.registerLazySingleton(
    () => GetUserProfileUseCase(sl.get<AuthRepository>()),
  );
  sl.registerLazySingleton(() => Updateuserusecase(sl.get<AuthRepository>()));

  // Use cases for products are registered in product_service_locator.dart
  sl.registerLazySingleton(
    () => GetProductsUseCase(sl.get<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSearchProductsUseCase(sl.get<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetProductsByCategoryUseCase(sl.get<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetProductByIdUseCase(sl.get<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetAllCategoriesUseCase(sl.get<ProductRepository>()),
  );
  // --- Presentation Layer ---
  // Cubit for state management in the UI layer
  sl.registerFactory(
    () => AuthCubit(
      loginUsecase: sl.get<LoginUsecase>(),
      logoutUsecase: sl.get<LogoutUsecase>(),
      registerUsecase: sl.get<RegisterUsecase>(),
      getUserProfileUseCase: sl.get<GetUserProfileUseCase>(),
      updateuserusecase: sl.get<Updateuserusecase>(),
    ),
  );

  // Cubit for products is registered in product_service_locator.dart
  sl.registerFactory(
    () => ProductsCubit(
      getProductsUseCase: sl.get<GetProductsUseCase>(),
      getAllCategoriesUseCase: sl.get<GetAllCategoriesUseCase>(),
      getProductByIdUseCase: sl.get<GetProductByIdUseCase>(),
      getSearchProductsUseCase: sl.get<GetSearchProductsUseCase>(),
      getProductsByCategoryUseCase: sl.get<GetProductsByCategoryUseCase>(),
    ),
  );
  sl.registerFactory(() => CategoriesCubit(sl.get<GetAllCategoriesUseCase>()));
  sl.registerFactory(() => FeaturedProductsCubit(sl.get<GetProductsUseCase>()));
  sl.registerFactory(
    () => ProductsListCubit(
      getProductsUseCase: sl.get<GetProductsUseCase>(),
      productsByCategoryUseCase: sl.get<GetProductsByCategoryUseCase>(),
    ),
  );
  sl.registerFactory(
    () => ProductDetailCubit(
      getProductByIdUseCase: sl.get<GetProductByIdUseCase>(),
    ),
  );

  sl.registerFactory(
    () => SearchCubit(
      getSearchProductsUseCase: sl.get<GetSearchProductsUseCase>(),
    ),
  );
}
