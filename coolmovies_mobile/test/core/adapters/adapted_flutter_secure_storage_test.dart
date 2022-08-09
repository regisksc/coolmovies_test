import 'dart:convert';

import 'package:coolmovies/core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AdaptedFlutterSecureStorage sut;
  late FlutterSecureStorage storage;

  setUp(() {
    storage = MockFlutterSecureStorage();
    sut = AdaptedFlutterSecureStorage(storage);
  });

  test(
    "Should successfully retrieve values",
    () async {
      // Arrange
      when(() => storage.read(key: any(named: 'key'))).thenAnswer(
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
      when(() => storage.read(key: any(named: 'key'))).thenAnswer(
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
      when(() =>
              storage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) => futureCompletion);
      // Act
      sut.write("key", "value");
      // Assert
      verify(() =>
          storage.write(key: any(named: 'key'), value: any(named: 'value')));
      expect(sut.write("any", "value"), completes);
    },
  );
}
