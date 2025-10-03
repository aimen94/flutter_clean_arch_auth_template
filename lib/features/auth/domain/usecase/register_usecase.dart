import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase(this.authRepository);

  Future<Either<Failures, UserEntity>> call(RegisterParams registerParams) {
    return authRepository.register(
      username: registerParams.username,
      email: registerParams.email,
      firstName: registerParams.firstName,
      lastName: registerParams.lastName,
      age: registerParams.age,
      password: registerParams.password,
    );
  }
}

class RegisterParams {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String password;

  RegisterParams({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.password,
  });
}
