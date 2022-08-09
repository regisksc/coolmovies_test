import 'package:coolmovies/providers/providers.dart';
import 'package:coolmovies/repositories/repositories.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers/mock_objects.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserProvider sut;
  late MockUserRepository repository;

  setUp(() {
    repository = MockUserRepository();
    sut = UserProvider(repository);
  });

  test(
    "should update state when getUser ends in success",
    () async {
      // Arrange
      final fromRepository = mockUserModel;
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async => Right(fromRepository),
      );
      // Act
      sut.addListener(() {
        expect(sut.user, equals(fromRepository));
      });
      await sut.getCurrentUser();
      // Assert
      verify(() => repository.getCurrentUser());
    },
  );

  test(
    "should update last failure when getCurrentUser fails",
    () async {
      // Arrange
      final failure = mockFailure;
      when(() => repository.getCurrentUser()).thenAnswer(
        (_) async => Left(failure),
      );
      // Act
      sut.addListener(() {
        expect(sut.lastRequestFailure, isNotNull);
        expect(sut.lastRequestFailure, equals(failure));
      });
      await sut.getCurrentUser();
      // Assert
      verify(() => repository.getCurrentUser());
    },
  );
}
