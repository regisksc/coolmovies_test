import 'package:coolmovies/providers/movie_provider.dart';
import 'package:coolmovies/repositories/repositories.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers/mock_objects.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MoviesProvider sut;
  late MockMovieRepository repository;

  setUpAll(() {
    registerFallbackValue(mockMovieReviewModel);
  });

  setUp(() {
    repository = MockMovieRepository();
    sut = MoviesProvider(repository);
  });

  test(
    "should update state when getMovies ends in success",
    () async {
      // Arrange
      final fromRepository = mockMovieList();
      when(() => repository.getAllMovies()).thenAnswer(
        (_) async => Right(fromRepository),
      );
      // Act
      sut.addListener(() {
        expect(sut.movies, isNotEmpty);
        expect(sut.movies, equals(fromRepository));
        expect(sut.movies.length, equals(fromRepository.length));
      });
      await sut.getMovies();
      // Assert
      verify(() => repository.getAllMovies());
    },
  );

  test(
    "should update last failure when getAllMovies fails",
    () async {
      // Arrange
      final fromStorage = mockMovieList();
      final failure = mockFailureWith(fromStorage);
      when(() => repository.getAllMovies()).thenAnswer(
        (_) async => Left(failure),
      );
      // Act
      sut.addListener(() {
        expect(sut.lastRequestFailure, isNotNull);
        expect(sut.lastRequestFailure, equals(failure));
      });
      await sut.getMovies();
      // Assert
      verify(() => repository.getAllMovies());
    },
  );

  test(
    "should replace review on edit save action",
    () async {
      // Arrange
      when(() => repository.storeMovies(any()))
          .thenAnswer((_) => Future.value());
      when(() => repository.remoteAddReview(
            movieId: any(named: 'movieId'),
            userId: any(named: 'userId'),
            review: any(named: 'review'),
          )).thenAnswer((_) => Future.value());
      when(() => repository.remoteEditReview(
            movieId: any(named: 'movieId'),
            userId: any(named: 'userId'),
            review: any(named: 'review'),
          )).thenAnswer((_) => Future.value());
      when(() => repository.storeMovies(any()))
          .thenAnswer((_) => Future.value());
      final movies = mockMovieList();
      final user = mockUserModel;
      final reviewToBeEdited = movies[0].reviews[0];
      final firstTitle = reviewToBeEdited.title;
      // Act
      sut.startEditingReview(reviewToBeEdited);
      reviewToBeEdited.title = 'newTitle';
      reviewToBeEdited.title = 'body';
      sut.stopEditingReview(user, reviewToBeEdited, shouldSave: true);
      final newTitle = reviewToBeEdited.title;
      // Assert
      verify(() => repository.storeMovies(any()));
      verify(() => repository.remoteEditReview(
            movieId: any(named: 'movieId'),
            userId: any(named: 'userId'),
            review: any(named: 'review'),
          ));
      expect(newTitle, isNot(firstTitle));
    },
  );

  test(
    "should not replace review on edit cancel action",
    () async {
      // Arrange
      final movies = mockMovieList();
      final user = mockUserModel;
      final reviewToBeEdited = movies[0].reviews[0];
      final titleBefore = reviewToBeEdited.title;
      // Act
      sut.startEditingReview(reviewToBeEdited);
      reviewToBeEdited.title = 'newTitle';
      sut.stopEditingReview(user, reviewToBeEdited);
      final titleAfter = reviewToBeEdited.title;
      // Assert
      verifyNever(() => repository.storeMovies(any()));
      expect(titleBefore, equals(titleAfter));
    },
  );
}
