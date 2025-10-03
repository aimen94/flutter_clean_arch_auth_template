import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/storage_keys.dart';
import 'package:flutter_application_2/core/storage/secure_storage_manager.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/login_screen.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/profile_screen.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/register_screen.dart';
import 'package:flutter_application_2/features/home/presentions/pages/home_page.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/product_detail/product_detail_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_cubit.dart';
import 'package:flutter_application_2/features/products/presentions/pages/product_details_screen.dart';
import 'package:flutter_application_2/features/products/presentions/pages/products_screen.dart';
import 'package:flutter_application_2/features/products/presentions/pages/search_products.dart';
import 'package:flutter_application_2/features/settings/presentions/pages/settings_screen.dart';
import 'package:flutter_application_2/features/shell/presentions/pages/main_shell.dart';
import 'package:flutter_application_2/features/update_profile.dart';
import 'package:flutter_application_2/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home', // ابدأ بالـ Home، الـ redirect سيتولى الباقي
    // --- منطق الحماية وإعادة التوجيه ---
    redirect: (context, state) async {
      final secureStorage =
          sl<SecureStorageManager>(); // ✨ استخدام الواجهة النظيفة
      final accessToken = await secureStorage.red(StorageKeys.accessToken);
      final isLoggedIn = accessToken != null;

      final isGoingToAuth =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isGoingToAuth) return '/login';
      if (isLoggedIn && isGoingToAuth) return '/home';

      return null;
    },

    routes: [
      // =========================================================================
      // Routes خارج ה-Shell (شاشات بملء الشاشة بدون BottomNavBar)
      // =========================================================================
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(
        path: '/search-products',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<SearchCubit>(),
            child: SearchProductsScreen(),
          );
        },
      ),
      GoRoute(
        path: '/productDetail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return BlocProvider(
            create: (context) =>
                sl<ProductDetailCubit>()..fetchProductByID(productId),
            child: ProductDetailsScreen(),
          );
        },
      ),

      GoRoute(
        path: '/profile/update',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UpdateProfileScreen(currentUser: user);
        },
      ),

      // =========================================================================
      // Route حاضن لكل الشاشات الداخلية (مع BottomNavBar)
      // =========================================================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // --- الفرع 0: Home ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (c) => sl<CategoriesCubit>()..fetchCategories(),
                    ),
                    BlocProvider(
                      create: (c) =>
                          sl<FeaturedProductsCubit>()..fetchFeaturedProducts(),
                    ),

                    /////
                    BlocProvider(create: (context) => sl<ProductsListCubit>()),
                  ],

                  child: HomeScreen(),
                ),
              ),
            ],
          ),

          // --- الفرع 1: Products ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                builder: (context, state) {
                  final category = state.uri.queryParameters['category'];
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (c) => sl<CategoriesCubit>()..fetchCategories(),
                      ),
                      BlocProvider(
                        create: (c) {
                          final cubit = sl<ProductsListCubit>();
                          if (category != null) {
                            cubit.fetchInitialProductsByCategory(category);
                          } else {
                            cubit.fetchInitialProducts();
                          }
                          return cubit;
                        },
                      ),
                    ],
                    child: ProductsScreen(),
                  );
                },
              ),
            ],
          ),

          // --- الفرع 2: Settings ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),

          // --- الفرع 3: Profile ---
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/core/constants/storage_keys.dart';
// import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
// import 'package:flutter_application_2/features/home/presentions/pages/home_page.dart';
// import 'package:flutter_application_2/features/auth/presentions/pages/login_screen.dart';
// import 'package:flutter_application_2/features/auth/presentions/pages/profile_screen.dart';
// import 'package:flutter_application_2/features/auth/presentions/pages/register_screen.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/categories/categories_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/featured_products/featured_products_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/products_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/products_list/products_list_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/cubit/searche/searche_cubit.dart';
// import 'package:flutter_application_2/features/products/presentions/pages/product_details_screen.dart';
// import 'package:flutter_application_2/features/products/presentions/pages/products_screen.dart';
// import 'package:flutter_application_2/features/products/presentions/pages/search_products.dart';
// import 'package:flutter_application_2/features/products/presentions/pages/product_detail_screen%20.dart';
// import 'package:flutter_application_2/features/settings/presentions/pages/settings_screen.dart';
// import 'package:flutter_application_2/features/shell/presentions/pages/main_shell.dart';
// import 'package:flutter_application_2/features/update_profile.dart';
// import 'package:flutter_application_2/service_locator.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:go_router/go_router.dart';

// import '../features/products/presentions/cubit/product_detail/product_detail_cubit.dart';

// /// Application router configuration using GoRouter
// ///
// /// This class manages all application navigation and implements
// /// authentication-based route protection. It automatically redirects
// /// users based on their authentication status.
// ///
// /// Features:
// /// - Protected routes requiring authentication
// /// - Automatic redirects based on auth state
// /// - BlocProvider integration for state management
// /// - Clean route definitions with path constants
// class AppRouter {
//   /// Route path constants for easy maintenance
//   static String home = '/home';
//   static String login = '/login';
//   static String register = '/register';
//   static String profile = '/profile';
//   static final _rootNavigatorKey = GlobalKey<NavigatorState>();

//   /// Main router configuration with authentication logic
//   ///
//   /// The router automatically handles:
//   /// - Initial route selection
//   /// - Route protection and redirects
//   /// - BlocProvider integration for state management
//   /// - Authentication state validation
//   static final router = GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     // Start with login screen for unauthenticated users
//     initialLocation: login,

//     /// Authentication-based route protection and redirects
//     ///
//     /// This function runs before every navigation and ensures:
//     /// - Unauthenticated users can only access login/register
//     /// - Authenticated users are redirected to home from auth screens
//     /// - Protected routes require valid authentication tokens
//     ///
//     /// [context] - Build context for accessing services
//     /// [state] - Current router state with location information
//     /// Returns the path to redirect to, or null to allow navigation
//     redirect: (BuildContext context, GoRouterState state) async {
//       // Access secure storage to check authentication status
//       final secureStorge = sl<FlutterSecureStorage>();
//       final accessToken = await secureStorge.read(key: StorageKeys.accessToken);

//       // Determine if user is authenticated based on token presence
//       final bool isLoggedIn = accessToken != null;
//       final String location = state.uri.toString();
//       final isGoingToAuthPage = location == login || location == '/register';

//       // Redirect unauthenticated users to login (except for auth routes)
//       if (!isLoggedIn && !isGoingToAuthPage) {
//         return login;
//       }

//       // Redirect authenticated users away from auth screens to home
//       if (isLoggedIn && isGoingToAuthPage) {
//         return '/home';
//       }

//       // Allow navigation to proceed normally
//       return null;
//     },

//     // Define all application routes
//     routes: [
//       GoRoute(
//         path: '/profile/update',
//         parentNavigatorKey: _rootNavigatorKey,
//         builder: (context, state) {
//           final user = state.extra as UserEntity;
//           return UpdateProfile(currentUser: user);
//         },
//       ),

//       // Public authentication routes
//       GoRoute(path: login, builder: (context, state) => const LoginScreen()),
//       GoRoute(
//         path: '/productDetail/:id', // المسار به معلمة :id
//         parentNavigatorKey: _rootNavigatorKey,
//         builder: (context, state) {
//           final productId = int.parse(
//             state.pathParameters['id']!,
//           ); // استخراج المعلمة
//           return BlocProvider(
//             create: (context) =>
//                 sl<ProductDetailCubit>()..fetchProductByID(productId),
//             child: ProductDetailsScreen(),
//           );
//         },
//       ),
//       GoRoute(
//         path: register,
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       StatefulShellRoute.indexedStack(
//         builder: (context, state, navigationShell) {
//           return MainShell(navigationShell: navigationShell);
//         },
//         branches: [
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/home',
//                 builder: (context, state) {
//                   // return BlocProvider(
//                   //   create: (context) => sl<ProductsCubit>()
//                   //     ..fetchAllCategories()
//                   //     ..fetchInitialProducts(1, 0),
//                   return MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                         create: (context) =>
//                             sl<CategoriesCubit>()..fetchCategories(),
//                       ),
//                       BlocProvider(
//                         create: (context) =>
//                             sl<FeaturedProductsCubit>()
//                               ..fetchFeaturedProducts(),
//                       ),
//                       BlocProvider(
//                         create: (context) => sl<ProductsListCubit>(),
//                       ),
//                       //must delete it later
//                       BlocProvider(
//                         create: (context) => sl<ProductsCubit>()
//                           ..fetchAllCategories()
//                           ..fetchInitialProducts(1, 0),
//                       ),
//                     ],
//                     child: HomeScreen(),
//                   );
//                 },
//                 routes: [
//                   GoRoute(
//                     path: '/profile',
//                     builder: (context, state) => const ProfileScreen(),
//                   ),
//                   // GoRoute(
//                   //   path: '/search-products',
//                   //   builder: (context, state) {
//                   //     return MultiBlocProvider(
//                   //       providers: [
//                   //         BlocProvider(
//                   //           create: (context) =>
//                   //               sl<SearcheCubit>()..fetchSearchProducts(""),
//                   //         ),
//                   //         BlocProvider(
//                   //           create: (context) => sl<ProductsListCubit>()
//                   //             ..fetchInitialProducts()
//                   //             ..fetchMoreProducts(),
//                   //         ),
//                   //       ],
//                   //       child: SearchProducts(),
//                   //     );
//                   //   },
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/products',
//                 builder: (context, state) {
//                   return MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                         create: (context) => sl<ProductsListCubit>()
//                           ..fetchInitialProducts()
//                           ..fetchMoreProducts(),
//                       ),
//                       BlocProvider(
//                         create: (context) =>
//                             sl<CategoriesCubit>()..fetchCategories(),
//                       ),
//                     ],
//                     child: ProductsScreen(),
//                   );
//                 },
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/settings',
//                 builder: (context, state) => const SettingsScreen(),
//               ),
//             ],
//           ),
//           StatefulShellBranch(
//             routes: [
//               GoRoute(
//                 path: '/profile',
//                 builder: (context, state) => const ProfileScreen(),
//               ),
//               GoRoute(
//                 path: '/search-products',
//                 builder: (context, state) {
//                   return MultiBlocProvider(
//                     providers: [
//                       BlocProvider(
//                         create: (context) =>
//                             sl<SearcheCubit>()..searcheProducts(query),
//                       ),
//                       // BlocProvider(
//                       //   create: (context) => sl<ProductsListCubit>()
//                       //     ..fetchInitialProducts()
//                       //     ..fetchMoreProducts(),
//                       // ),
//                     ],
//                     child: SearchProducts(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     ],
//   );
// }
