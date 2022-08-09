import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/mock_objects.dart';

void main() {
  test(
    "test toJson",
    () async {
      // Arrange
      final model = mockMovieReviewModel;
      // Act
      final json = model.toJson;
      // Assert
      expect(
        json,
        equals(
          {
            "id": model.id,
            "movieId": model.movieId,
            "body": model.body,
            "title": model.title,
            "rating": model.rating,
            "userByUserReviewerId": model.createdBy.toJson,
          },
        ),
      );
    },
  );
  test(
    "copyWith should generate an instance with new data",
    () async {
      // Arrange
      final model = mockMovieReviewModel;
      // Act
      final newModel = model.copyWith(id: faker.guid.guid());
      // Assert
      expect(model.id, isNot(newModel.id));
      expect(model.createdBy, equals(newModel.createdBy));
      expect(model.body, equals(newModel.body));
      expect(model.title, equals(newModel.title));
      expect(model.rating, equals(newModel.rating));
    },
  );
}
