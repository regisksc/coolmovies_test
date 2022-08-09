import 'package:coolmovies/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "test NoParams is equatable",
    () async {
      // Arrange
      const instance1 = NoParams();
      const instance2 = NoParams();
      // Act

      // Assert
      expect(instance1, equals(instance2));
      expect(instance1.props, isEmpty);
      expect(instance2.props, isEmpty);
    },
  );
}
