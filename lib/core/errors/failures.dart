import 'package:equatable/equatable.dart';

class Failures extends Equatable {
  final String message;
  const Failures({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failures {
  const ServerFailure({required super.message});
}

class NetworkFailure extends Failures {
  NetworkFailure({required super.message});
}

class CashFailure extends Failures {
  const CashFailure({required super.message});
}

class UnauthorizedFailure extends Failures {
  const UnauthorizedFailure({required super.message});
}
