import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/domin/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateProfile extends StatefulWidget {
  final UserEntity currentUser;

  UpdateProfile({super.key, required this.currentUser});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

@override
class _UpdateProfileState extends State<UpdateProfile> {
  late final TextEditingController _firstNameController;

  late final TextEditingController _lastNameController;
  void initState() {
    super.initState();

    _firstNameController = TextEditingController(
      text: widget.currentUser.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.currentUser.lastName,
    );
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('update profile')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErorr) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.green,
                ),
              );
            context.pop();
          }
          if (state is authSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green, // تحسين
                  content: Text(
                    // ✨ تصحيح اسم المتغير
                    'Success! Profile for ${state.userEntity.username} updated.',
                  ),
                ),
              );
            // ✨ مهم: ارجع إلى الشاشة السابقة بعد النجاح
            context.pop();
          }
        },
        child: Column(
          children: [
            Text('update profile'),

            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const SizedBox(
                          height: 50,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          context.read<AuthCubit>().updateProfile(
                            _firstNameController.text.trim(),
                            _lastNameController.text.trim(),
                          );
                        },
                        child: Text('update '),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
