import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';

import '../../core.dart';

abstract class Usecase<Output, Input> {
  Future<Either<Failure, Output>> call(Input params);
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
