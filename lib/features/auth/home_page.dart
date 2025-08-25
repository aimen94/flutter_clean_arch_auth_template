import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Home screen widget that displays user profile and provides navigation
///
/// This screen serves as the main authenticated area of the application.
/// It displays user profile information, provides logout functionality,
/// and allows users to refresh their profile data.
///
/// Features:
/// - User profile display with avatar and information
/// - Logout functionality
/// - Profile data refresh capability
/// - Responsive design with modern UI elements
/// - Automatic navigation on logout
class HomeScreen extends StatelessWidget {
  /// Creates a HomeScreen widget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          // Logout button in app bar
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        // Listen to authentication state changes
        listener: (context, state) {
          if (state is Unauthenticated) {
            // Redirect to login screen on logout
            context.go('/login');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Main content area with profile information
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    // Show loading indicator during operations
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is authSuccess) {
                    // Display user profile information
                    return Column(
                      children: [
                        // User avatar with profile image or initials
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Text(
                              state.userEntity.fullName[0].toUpperCase(),
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // User's full name
                        Text(
                          state.userEntity.fullName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        // User's email address
                        Text(
                          state.userEntity.email,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 32),
                        // Profile information card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Username information row
                              _InfoRow(
                                icon: Icons.person_outline_rounded,
                                label: 'Username',
                                value: state.userEntity.username,
                              ),
                              const SizedBox(height: 16),
                              // Gender information row
                              _InfoRow(
                                icon: Icons.female_rounded,
                                label: 'Gender',
                                value: state.userEntity.gender,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  if (state is AuthErorr) {
                    // Display error state with error message
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Default state when no profile data is loaded
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Press the button to fetch your profile',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              const Spacer(),
              // Profile refresh button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().GetUserProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Fetch User Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper widget for displaying profile information rows
///
/// This widget provides a consistent layout for displaying
/// profile information with an icon, label, and value.
///
/// Features:
/// - Icon representation for the information type
/// - Label describing the information
/// - Value display with appropriate styling
class _InfoRow extends StatelessWidget {
  /// Icon representing the information type
  final IconData icon;

  /// Label describing the information
  final String label;

  /// Value to display
  final String value;

  /// Creates an InfoRow widget
  ///
  /// [icon] - Icon to represent the information type
  /// [label] - Label describing the information
  /// [value] - Value to display
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Information icon
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        // Label and value column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information label
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            // Information value
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
// import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar.new(
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.read<AuthCubit>().logout();
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: BlocListener<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthLoading) {
//             CircularProgressIndicator();
//           } else if (state is Unauthenticated) {
//             context.go('/login');
//           }
//         },
//         child: Column(
//           children: [
//             BlocBuilder<AuthCubit, AuthState>(
//               builder: (context, state) {
//                 if (state is AuthLoading) {
//                   CircularProgressIndicator();
//                 }
//                 if (state is authSuccess) {
//                   return Column(
//                     spacing: 16,
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.cyan[100],
//                         child: Text(
//                           state.userEntity.fullName,
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       ),

//                       Text(state.userEntity.email),
//                       Text('username: ${state.userEntity.username}'),
//                       Text('gander: ${state.userEntity.gender}'),
//                     ],
//                   );
//                 }
//                 if (state is AuthErorr) {
//                   return Center(child: Text('${state.errorMessage}'));
//                 }
//                 return const Center(
//                   child: Text('Press the button to fetch your profile.'),
//                 );
//               },
//             ),
//             const Spacer(),
//             ElevatedButton.icon(
//               onPressed: () {
//                 context.read<AuthCubit>().GetUserProfile();
//               },
//               icon: const Icon(Icons.refresh),

//               label: Text('Fetch User Profile details'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
