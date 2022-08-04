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
            "body": model.body,
            "title": model.title,
            "rating": model.rating,
            "userByUserReviewerId": model.createdBy,
          },
        ),
      );
    },
  );
}
