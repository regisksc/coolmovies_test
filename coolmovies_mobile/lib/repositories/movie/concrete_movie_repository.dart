import 'package:either_dart/either.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/core.dart';
import '../../core/graphql/graphql_mutations.dart';
import '../repositories.dart';

class ConcreteMovieRepository implements MovieRepository {
  ConcreteMovieRepository(
    this.client,
    this.storage,
  );
  final GraphQLClient client;
  final StorageAdapter storage;

  String get _storageKey => 'allMovies';

  @override
  Future<Either<Failure, List<MovieModel>>> getAllMovies() async {
    return client.performFetchListQuery(
      storage: storage,
      mapKey: _storageKey,
      gqlQuery: GQLQueries.getAllMovies,
      serializer: MovieModel.fromJson,
    );
  }

  @override
  Future<Either<Failure, List<MovieReviewModel>>> getMovieReviewsFor(
    String movieId, {
    required int page,
  }) async {
    return client.performFetchListQuery(
      mapKey: 'allMovieReviews',
      gqlQuery: GQLQueries.getReviewsForMovieId(movieId, pageNum: page),
      serializer: MovieReviewModel.fromJson,
    );
  }

  @override
  Future storeMovies(List<MovieModel> movies) async {
    storage.write(_storageKey, {
      _storageKey: {
        'nodes': movies.map((e) => e.toJson).toList(),
      }
    });
  }

  @override
  Future remoteAddReview({
    required String movieId,
    required String userId,
    required MovieReviewModel review,
  }) {
    return client.performMutation(
      gqlQuery: GQLMutations.createMovieReview(
        movieReviewMap: {
          "id": review.id,
          "title": review.title,
          "body": review.body,
          "rating": review.rating,
          "movieId": movieId,
          "userReviewerId": userId,
        },
      ),
    );
  }

  @override
  Future remoteEditReview({
    required String movieId,
    required String userId,
    required MovieReviewModel review,
  }) {
    return client.performMutation(
      gqlQuery: GQLMutations.updateMovieReview(
        movieReviewMap: {
          "title": review.title,
          "body": review.body,
          "rating": review.rating,
          "movieId": movieId,
          "userReviewerId": userId,
        },
      ),
    );
  }
}
