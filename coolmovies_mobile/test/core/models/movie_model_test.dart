import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers/mock_objects.dart';

void main() {
  test(
    "test toJson",
    () async {
      // Arrange
      final model = mockMovieModel();
      // Act
      final json = model.toJson;
      // Assert
      expect(
        json,
        equals(
          {
            "id": model.id,
            "imgUrl": model.imgUrl,
            "title": model.title,
            "releaseDate": model.releaseDate,
            "movieDirectorByMovieDirectorId": {"name": model.directorName},
            "movieReviewsByMovieId": {
              "nodes": model.reviews.map((e) => e.toJson).toList()
            },
            "userByUserCreatorId": model.createdBy.toJson,
            "description": model.description,
          },
        ),
      );
    },
  );
  test(
    "formattedReleaseDate",
    () async {
      // Arrange
      final model = mockMovieModel();
      final year = model.releaseDate!.split("-")[0];
      final day = model.releaseDate!.split("-")[2];
      // Act
      final date = model.formattedReleaseDate;
      // Assert
      expect(date, contains(year));
      expect(date, contains(day));
    },
  );

  test(
    "movie rating",
    () async {
      // Arrange
      final model = mockMovieModel();
      final reviewRatings = model.reviews.map((e) => e.rating).toList();
      final manualAverageRating =
          reviewRatings.reduce((a, b) => a + b) / reviewRatings.length;
      final roundedAverage =
          double.parse(manualAverageRating.toStringAsFixed(1));
      // Act
      final averageRating = model.rating;
      // Assert
      expect(averageRating, equals(roundedAverage));
    },
  );
  test(
    "movie release year",
    () async {
      // Arrange
      final model = mockMovieModel();
      final manualReleaseYear = model.releaseDate?.split('-').first ?? "";
      // Act
      final year = model.releaseYear;
      // Assert
      expect(year, equals(manualReleaseYear));
    },
  );

  test(
    "movie release year should be empty when release date is empty",
    () async {
      // Arrange
      final model = mockMovieModel(makeReleaseDateNull: true);
      // Act
      final year = model.releaseYear;
      // Assert
      expect(year, equals(""));
    },
  );

  test(
    "copyWith should generate an instance with new data",
    () async {
      // Arrange
      final model = mockMovieModel();
      // Act
      final newReview = mockMovieReviewModel;
      final newModel = model.copyWith(newReviews: [
        model.reviews[0],
        model.reviews[1],
        newReview, // !
      ]);
      // Assert
      expect(model.createdBy, equals(newModel.createdBy));
      expect(model.description, equals(newModel.description));
      expect(model.directorName, equals(newModel.directorName));
      expect(model.title, equals(newModel.title));
      expect(model.description, equals(newModel.description));
      expect(model.id, equals(newModel.id));
      expect(model.imgUrl, equals(newModel.imgUrl));
      expect(model.releaseDate, equals(newModel.releaseDate));
      expect(model.reviews[0], equals(newModel.reviews[0]));
      expect(model.reviews[1], equals(newModel.reviews[1]));
      expect(model.reviews[2], isNot(newModel.reviews[2]));
    },
  );
}
