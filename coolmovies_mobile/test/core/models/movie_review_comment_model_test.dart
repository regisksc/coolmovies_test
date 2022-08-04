import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/mock_objects.dart';

void main() {
  test(
    "test toJson",
    () async {
      // Arrange
      final model = mockMovieReviewCommentModel;
      // Act
      final json = model.toJson;
      // Assert
      expect(
        json,
        equals(
          {
            'title': model.title,
            'id': model.id,
            'body': model.body,
            'movieReviewId': model.movieReviewId,
          },
        ),
      );
    },
  );
}
