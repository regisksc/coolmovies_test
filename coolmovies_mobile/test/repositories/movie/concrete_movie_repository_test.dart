import 'package:coolmovies/core/core.dart';
import 'package:coolmovies/core/graphql/graphql_mutations.dart';
import 'package:coolmovies/repositories/repositories.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers/mock_objects.dart';
import '../../test_helpers/mock_success_for_fixture.dart';
import '../user/concrete_user_repository_test.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

void main() {
  late MovieRepository sut;
  late MockGraphQLClient client;
  late MockAdaptedFlutterSecureStorage storage;
  late QueryOptions<Object?> queryOptions;
  late MutationOptions<Object?> mutationOptions;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    final gqlQueryDocNode = gql(GQLQueries.getAllMovies);
    final gqlMutationDocNode = gql(
      GQLMutations.createMovieReview(movieReviewMap: {}),
    );
    queryOptions = QueryOptions(document: gqlQueryDocNode);
    mutationOptions = MutationOptions(document: gqlMutationDocNode);
    registerFallbackValue(queryOptions);
    registerFallbackValue(mutationOptions);
  });

  setUp(
    () {
      client = MockGraphQLClient();
      storage = MockAdaptedFlutterSecureStorage();
      sut = ConcreteMovieRepository(client, storage);
    },
  );

  void arrangeCommonExecutions(
    MockGraphQLClient client, {
    required JSON resultData,
  }) {
    when(() => client.query(any())).thenAnswer(
      (_) async => QueryResult(
        options: queryOptions,
        source: QueryResultSource.network,
        data: resultData,
      ),
    );
  }

  group('test get all movies', () {
    test(
      "getAllMovies should return a List<MovieModel> on success",
      () async {
        // Arrange
        arrangeCommonExecutions(
          client,
          resultData: mockSuccessForFixture('all_movies.json'),
        );
        when(() => storage.write(any(), any())).thenAnswer(
          (_) async => Future.value(),
        );
        // Act
        final result = await sut.getAllMovies();
        final extract = result.fold((failure) => failure, (success) => success);
        // Assert
        verify(() => client.query(any()));
        expect(extract, isA<List<MovieModel>>());
        expect(extract, isNotEmpty);
      },
    );

    test(
      "getAllMovies should store returned List<MovieModel> on success",
      () async {
        // Arrange
        arrangeCommonExecutions(
          client,
          resultData: mockSuccessForFixture('all_movies.json'),
        );
        when(() => storage.write(any(), any())).thenAnswer(
          (_) async => Future.value(),
        );
        // Act
        await sut.getAllMovies();
        // Assert
        verify(() => storage.write(any(), any()));
      },
    );

    test(
      "getAllMovies should return a GQLRequestFailure on failure when result has exception",
      () async {
        // Arrange
        arrangeCommonExecutions(client,
            resultData: mockGraphQLRequestFailure());
        when(() => storage.read(any())).thenAnswer(
          (_) async => {},
        );
        // Act
        final result = await sut.getAllMovies();
        final extract = result.fold((failure) => failure, (success) => success);
        // Assert
        verify(() => client.query(any()));
        expect(extract, isA<GQLRequestFailure>());
      },
    );
    test(
      "getAllMovies should return a GQLRequestFailure with stored values if they exist",
      () async {
        // Arrange
        arrangeCommonExecutions(client,
            resultData: mockGraphQLRequestFailure());
        when(() => storage.read(any())).thenAnswer(
          (_) async => mockSuccessForFixture('all_movies.json'),
        );
        // Act
        final result = await sut.getAllMovies();
        final extract = result.fold((failure) => failure, (success) => success);
        extract as GQLRequestFailure;
        // Assert
        verify(() => storage.read(any()));
        expect(extract.valuesFromStorage, isNotEmpty);
      },
    );

    test(
      "getAllMovies should return a GQLRequestFailure without stored values if they don't exist",
      () async {
        // Arrange
        arrangeCommonExecutions(client,
            resultData: mockGraphQLRequestFailure());
        when(() => storage.read(any())).thenAnswer(
          (_) async => {},
        );
        // Act
        final result = await sut.getAllMovies();
        final extract = result.fold((failure) => failure, (success) => success);
        extract as GQLRequestFailure;
        // Assert
        verify(() => storage.read(any()));
        expect(extract.valuesFromStorage, isEmpty);
      },
    );
  });

  group('mutation tests', () {
    test("should add a movie review to the remote", () async {
      // Arrange
      final review = mockMovieReviewModel;
      mutationOptions = MutationOptions(
          document: gql(GQLMutations.createMovieReview(movieReviewMap: {
        "title": review.title,
        "body": review.body,
        "rating": review.rating,
        "movieId": review.movieId,
        "userReviewerId": review.createdBy.id,
      })));
      when(() => client.mutate(any())).thenAnswer(
        (_) async => QueryResult(
          options: mutationOptions,
          source: QueryResultSource.network,
          data: {},
        ),
      );
      final movieId = faker.guid.guid();
      final userId = faker.guid.guid();

      // Act
      final failureOrNull = await sut.remoteAddReview(
        movieId: movieId,
        userId: userId,
        review: review,
      );

      // Assert
      verifyNever(() => storage.read(any()));
      verifyNever(() => storage.write(any(), any()));
      expect(failureOrNull, isNull);
    });

    test("should edit a movie review in remote", () async {
      // Arrange
      when(() => client.mutate(any())).thenAnswer(
        (_) async => QueryResult(
          options: MutationOptions(
            document: gql(
              GQLMutations.createMovieReview(movieReviewMap: {}),
            ),
          ),
          source: QueryResultSource.network,
          data: {},
        ),
      );
      final movieId = faker.guid.guid();
      final userId = faker.guid.guid();
      final review = mockMovieReviewModel;

      // Act
      final failureOrNull = await sut.remoteEditReview(
        movieId: movieId,
        userId: userId,
        review: review,
      );

      // Assert
      verifyNever(() => storage.read(any()));
      verifyNever(() => storage.write(any(), any()));
      expect(failureOrNull, isNull);
    });
  });

  test(
    "stores new movie list when storeMovies is called",
    () async {
      // Arrange
      when(() => storage.write(any(), any())).thenAnswer((_) => Future.value());
      final movieList = mockMovieList();
      // Act

      // Assert
      expect(sut.storeMovies(movieList), completes);
      verify(() => storage.write(any(), any()));
    },
  );

  test(
    "should fetch a list of movie reviews for a movie",
    () async {
      // Arrange
      final movieId = faker.guid.guid();
      final doc = gql(GQLQueries.getReviewsForMovieId(movieId, pageNum: 1));
      queryOptions = QueryOptions(document: doc);
      arrangeCommonExecutions(
        client,
        resultData: mockSuccessForFixture('all_review_by_id.json'),
      );
      // Act
      final reviews = await sut.getMovieReviewsFor(movieId, page: 1);
      final extract = reviews.fold((fail) => fail, (success) => success);
      // Assert
      verifyNever(() => storage.write(any(), any()));
      verifyNever(() => storage.read(any()));
      expect(extract, isA<List<MovieReviewModel>>());
    },
  );
}
