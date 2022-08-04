import 'dart:convert';

import 'package:coolmovies/core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'adapted_flutter_secure_storage_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late AdaptedFlutterSecureStorage sut;
  late MockFlutterSecureStorage storage;

  setUp(() {
    storage = MockFlutterSecureStorage();
    sut = AdaptedFlutterSecureStorage(storage);
  });

  test(
    "Should successfully retrieve values",
    () async {
      // Arrange
      when(storage.read(key: anyNamed('key'))).thenAnswer(
        (_) async => jsonEncode({"key": "value"}),
      );
      // Act
      final retrievedValue = await sut.read("any");
      // Assert
      expect(retrievedValue["key"], equals("value"));
    },
  );

  test(
    "Should return an empty map when key is not present",
    () async {
      // Arrange
      when(storage.read(key: anyNamed('key'))).thenAnswer(
        (_) async => null,
      );
      // Act
      final retrievedValue = await sut.read("any");
      // Assert
      final emptyMap = {};
      expect(retrievedValue, equals(emptyMap));
    },
  );

  test(
    "Should successfully write values",
    () async {
      // Arrange
      final futureCompletion = Future.value();
      when(storage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) => futureCompletion);
      // Act
      sut.write("key", "value");
      // Assert
      verify(storage.write(key: anyNamed('key'), value: anyNamed('value')));
      expect(sut.write("any", "value"), completes);
    },
  );
}
