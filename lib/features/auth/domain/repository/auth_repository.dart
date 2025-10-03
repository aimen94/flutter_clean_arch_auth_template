import 'package:dartz/dartz.dart';
import 'package:flutter_application_2/core/errors/failures.dart';
import 'package:flutter_application_2/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failures, UserEntity>> login(String username, String password);

  Future<Either<Failures, UserEntity>> register({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required int age,
    required String password,
  });

  Future<Either<Failures, void>> logout();
  Future<Either<Failures, UserEntity>> getUserProfile();
  Future<Either<Failures, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
  });
}
