import 'package:either_dart/either.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/core.dart';
import '../repositories.dart';

class ConcreteMovieRepository implements MovieRepository {
  ConcreteMovieRepository(
    this.client,
    this.storage,
  );
  final GraphQLClient client;
  final StorageAdapter storage;

  @override
  Future<Either<Failure, List<MovieModel>>> getAllMovies() async {
    return client.performFetchListQuery(
      storage,
      storageKey: 'allMovies',
      gqlQuery: GQLQueries.getAllMovies,
      serializer: MovieModel.fromJson,
    );
  }
}
