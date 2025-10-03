import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';
import 'package:flutter_application_2/features/auth/domain/repository/auth_repository.dart';

class GetUserProfileUseCase {
  final AuthRepository authRepository;
  GetUserProfileUseCase(this.authRepository);

  Future<Either<Failures, UserEntity>> call() async {
    return await authRepository.getUserProfile();
  }
}
