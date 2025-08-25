// This file contains a commented-out profile page implementation
// The original implementation had some issues and was replaced with
// a more comprehensive home page that includes profile functionality

// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// Profile page widget for displaying user information
// /// 
// /// This widget was designed to show user profile details
// /// but had some implementation issues and was replaced.
// /// 
// /// The current profile functionality is integrated into
// /// the home page for better user experience.
// class MyProfile extends StatelessWidget {
//   /// Creates a MyProfile widget
//   const MyProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Profile"),
//       ),
//       body: Column(
//           spacing: 8,
//           children: [
//             Text("Email: ${context.watch<AuthCubit>().state.userEntity.email}"),
//             Text("First Name: ${context.watch<AuthCubit>().state.userEntity.firstName}"),
//             Text("Last Name: ${context.watch<AuthCubit>().state.userEntity.lastName}"),
//             Text("Age: ${context.watch<AuthCubit>().state.userEntity.age}"),
//             Text("Password: ${context.watch<AuthCubit>().state.userEntity.password}"),
//           ]
//       ),
//     )
//   }
// }

/// Note: This file is kept for reference but the profile functionality
/// has been moved to the home page (home_page.dart) for better integration
/// and user experience. The home page now provides a comprehensive
/// profile view with better UI design and state management.
