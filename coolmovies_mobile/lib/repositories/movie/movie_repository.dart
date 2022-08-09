import 'package:either_dart/either.dart';

import '../../core/core.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieModel>>> getAllMovies();
  Future storeMovies(List<MovieModel> movies);
  Future remoteAddReview({
    required String movieId,
    required String userId,
    required MovieReviewModel review,
  });
  Future remoteEditReview({
    required String movieId,
    required String userId,
    required MovieReviewModel review,
  });
}
