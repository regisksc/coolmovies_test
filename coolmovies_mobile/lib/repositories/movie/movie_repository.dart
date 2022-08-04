import 'package:either_dart/either.dart';

import '../../core/core.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieModel>>> getAllMovies();
}
