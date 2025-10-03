import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository authRepository;
  UpdateUserUseCase(this.authRepository);

  Future<Either<Failures, UserEntity>> call(UpdateParams updateParams) async {
    return await authRepository.updateProfile(
      firstName: updateParams.firstName,
      lastName: updateParams.lastName,
    );
  }
}

class UpdateParams {
  final String firstName;
  final String lastName;
  UpdateParams({required this.firstName, required this.lastName});
}

// Compatibility wrapper for older code that referenced `Updateuserusecase` (lowercase)
class Updateuserusecase extends UpdateUserUseCase {
  Updateuserusecase(super.authRepository);
}
