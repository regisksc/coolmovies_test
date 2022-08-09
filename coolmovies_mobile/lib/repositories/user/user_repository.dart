import 'package:either_dart/either.dart';

import '../../core/core.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel>> getCurrentUser();
}
