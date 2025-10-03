import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';

class Updateuserusecase {
  AuthRepository authRepository;
  Updateuserusecase(this.authRepository);
  Future<Either<Failures, UserEntity>> call(UpdateParams updateparams) async {
    return await authRepository.updateProfile(
      firstName: updateparams.firstName,
      lastName: updateparams.lastName,
    );
  }
}

class UpdateParams {
  final String firstName;
  final String lastName;
  UpdateParams({required this.firstName, required this.lastName});
}
