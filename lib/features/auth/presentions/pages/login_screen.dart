import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
import 'package:flutter_application_2/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Login screen widget that provides user authentication interface
///
/// This screen allows users to authenticate with their username/email
/// and password. It integrates with the AuthCubit for state management
/// and provides a modern, responsive UI with proper form validation.
///
/// Features:
/// - Username/email input field
/// - Password input with visibility toggle
/// - Form validation and error handling
/// - Loading states during authentication
/// - Navigation to registration screen
/// - Automatic redirection on successful login
class LoginScreen extends StatelessWidget {
  /// Creates a LoginScreen widget
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create AuthCubit instance using dependency injection
      create: (_) => sl<AuthCubit>(),
      child: const LoginView(),
    );
  }
}

/// Main login view widget with form and state management
///
/// This widget handles the actual login form UI and integrates
/// with the AuthCubit to manage authentication state and operations.
///
/// The widget is stateful to manage form controllers and local UI state
/// like password visibility toggle.
class LoginView extends StatefulWidget {
  /// Creates a LoginView widget
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

/// State class for LoginView widget
///
/// Manages form controllers, local UI state, and form validation.
/// Integrates with AuthCubit to handle authentication operations
/// and respond to state changes.
class _LoginViewState extends State<LoginView> {
  /// Controller for username/email input field
  final _usernameController = TextEditingController();

  /// Controller for password input field
  final _passwordController = TextEditingController();

  /// Global key for form validation
  final _formKey = GlobalKey<FormState>();

  /// Toggle for password visibility (obscured/visible)
  bool _obscurePassword = true;

  @override
  /// Cleanup resources when widget is disposed
  ///
  /// Disposes text controllers to prevent memory leaks
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handles login form submission
  ///
  /// This method:
  /// 1. Validates the form using the form key
  /// 2. If validation passes, triggers login via AuthCubit
  /// 3. Form validation ensures required fields are filled
  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        // Listen to authentication state changes
        listener: (context, state) {
          if (state is AuthErorr) {
            // Show error message in snackbar
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is authSuccess) {
            // Show success message and navigate to home
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Logged in as ${state.userEntity.username}'),
                ),
              );
            context.go('/home');
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.vertical,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Header section with app branding
                  Column(
                    children: [
                      Icon(
                        Icons.lock_person_rounded,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Welcome Back",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to continue",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Login form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Username/email input field
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        // Password input field with visibility toggle
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Login button with loading state
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const SizedBox(
                                height: 50,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            return SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Navigation to registration screen
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Footer copyright
                  Text(
                    "© 2023 Your App Name",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
// import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
// import 'package:flutter_application_2/service_locator.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<AuthCubit>(),
//       child: const LoginView(),
//     );
//   }
// }

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() {
//     context.read<AuthCubit>().login(
//       _usernameController.text.trim(),
//       _passwordController.text.trim(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: BlocListener<AuthCubit, AuthState>(
//         listener: (context, state) {
//           if (state is AuthErorr) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(SnackBar(content: Text(state.errorMessage)));
//           } else if (state is authSuccess) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 SnackBar(
//                   content: Text('Logged in as ${state.userEntity.username}'),
//                 ),
//               );
//             context.go('/home');
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: 'Username'),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 32),
//               // استخدام BlocBuilder لإعادة بناء الزر فقط
//               BlocBuilder<AuthCubit, AuthState>(
//                 builder: (context, state) {
//                   if (state is AuthLoading) {
//                     return const CircularProgressIndicator();
//                   }
//                   return ElevatedButton(
//                     onPressed: _login,
//                     child: const Text('Login'),
//                   );
//                 },
//               ),

//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   context.go('/register');
//                 },
//                 child: const Text("Dont have an account? Register"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
