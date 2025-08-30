import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/constants/storage_keys.dart';
import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/home_page.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/login_screen.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/profile_screen.dart';
import 'package:flutter_application_2/features/auth/presentions/pages/register_screen.dart';
import 'package:flutter_application_2/features/products/presentions/pages/products_screen.dart';
import 'package:flutter_application_2/features/settings/presentions/pages/settings_screen.dart';
import 'package:flutter_application_2/features/shell/presentions/pages/main_shell.dart';
import 'package:flutter_application_2/features/update_profile.dart';
import 'package:flutter_application_2/service_locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

/// Application router configuration using GoRouter
///
/// This class manages all application navigation and implements
/// authentication-based route protection. It automatically redirects
/// users based on their authentication status.
///
/// Features:
/// - Protected routes requiring authentication
/// - Automatic redirects based on auth state
/// - BlocProvider integration for state management
/// - Clean route definitions with path constants
class AppRouter {
  /// Route path constants for easy maintenance
  static String home = '/home';
  static String login = '/login';
  static String register = '/register';
  static String profile = '/profile';
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Main router configuration with authentication logic
  ///
  /// The router automatically handles:
  /// - Initial route selection
  /// - Route protection and redirects
  /// - BlocProvider integration for state management
  /// - Authentication state validation
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Start with login screen for unauthenticated users
    initialLocation: login,

    /// Authentication-based route protection and redirects
    ///
    /// This function runs before every navigation and ensures:
    /// - Unauthenticated users can only access login/register
    /// - Authenticated users are redirected to home from auth screens
    /// - Protected routes require valid authentication tokens
    ///
    /// [context] - Build context for accessing services
    /// [state] - Current router state with location information
    /// Returns the path to redirect to, or null to allow navigation
    redirect: (BuildContext context, GoRouterState state) async {
      // Access secure storage to check authentication status
      final secureStorge = sl<FlutterSecureStorage>();
      final accessToken = await secureStorge.read(key: StorageKeys.accessToken);

      // Determine if user is authenticated based on token presence
      final bool isLoggedIn = accessToken != null;
      final String location = state.uri.toString();
      final isGoingToAuthPage = location == login || location == '/register';

      // Redirect unauthenticated users to login (except for auth routes)
      if (!isLoggedIn && !isGoingToAuthPage) {
        return login;
      }

      // Redirect authenticated users away from auth screens to home
      if (isLoggedIn && isGoingToAuthPage) {
        return '/home';
      }

      // Allow navigation to proceed normally
      return null;
    },

    // Define all application routes
    routes: [
      GoRoute(
        path: '/profile/update',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UpdateProfile(currentUser: user);
        },
      ),

      // Public authentication routes
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: '/profile',
                    builder: (context, state) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                builder: (context, state) => const ProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
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
