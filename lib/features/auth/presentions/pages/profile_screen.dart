// lib/features/auth/presentation/pages/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is authSuccess) {
                  return Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(state.userEntity.image),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.userEntity.fullName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(state.userEntity.email),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            context.push(
                              '/profile/update',
                              extra: state.userEntity,
                            );
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AuthErorr) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }

                return const Expanded(
                  child: Center(
                    child: Text('Press "Fetch Profile" to load your data.'),
                  ),
                );
              },
            ),

            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().getUserProfile();
              },
              child: const Text('Fetch Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
