import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:intl/intl.dart';

import '../core.dart';

class MovieModel extends Equatable {
  const MovieModel({
    required this.id,
    required this.title,
    this.description,
    this.imgUrl,
    this.releaseDate,
    this.directorName,
    this.reviews = const [],
    required this.createdBy,
  });

  factory MovieModel.fromJson(JSON json) {
    return MovieModel(
      title: json['title'] as String,
      id: json['id'] as String,
      createdBy: UserModel.fromJson(
        json['userByUserCreatorId'] as JSON,
      ),
      directorName: json['movieDirectorByMovieDirectorId']['name'] as String?,
      imgUrl: json['imgUrl'] as String?,
      releaseDate: json['releaseDate'] as String?,
      reviews: (json['movieReviewsByMovieId']['nodes'] as List)
          .map((e) => MovieReviewModel.fromJson(e as JSON))
          .toList(),
      description:
          json['description'] as String? ?? faker.lorem.sentences(4).join(" "),
    );
  }

  final String id;
  final String title;
  final String? description;
  final String? imgUrl;
  final String? releaseDate;
  final String? directorName;
  final List<MovieReviewModel> reviews;
  final UserModel createdBy;

  int get reviewCount => reviews.length;

  double get rating {
    if (reviews.isEmpty) return 5;
    final reviewRatings = reviews.map((e) => e.rating).toList();
    final averageRating =
        reviewRatings.reduce((a, b) => a + b) / reviewRatings.length;
    return double.parse(averageRating.toStringAsFixed(1));
  }

  String get ratingWStar => "⭐ $rating";

  String get formattedReleaseDate {
    if (releaseDate == null) return "";
    final dateSplit = releaseDate!.split("-").map((e) => int.parse(e)).toList();
    return DateFormat.yMMMd().format(
      DateTime(
        dateSplit[0],
        dateSplit[1],
        dateSplit[2],
      ),
    );
  }

  String get releaseYear => releaseDate?.split("-").first ?? "";

  void removeReview(MovieReviewModel review) => reviews.remove(review);

  JSON get toJson {
    return {
      "id": id,
      "imgUrl": imgUrl,
      "title": title,
      "releaseDate": releaseDate,
      "movieDirectorByMovieDirectorId": {"name": directorName},
      "movieReviewsByMovieId": {
        "nodes": reviews.map((review) => review.toJson).toList()
      },
      "userByUserCreatorId": createdBy.toJson,
      "description": description,
    };
  }

  @override
  List<Object> get props {
    return [id, title];
  }

  MovieModel copyWith({
    required List<MovieReviewModel> newReviews,
  }) {
    return MovieModel(
      id: id,
      title: title,
      description: description,
      imgUrl: imgUrl,
      releaseDate: releaseDate,
      directorName: directorName,
      reviews: newReviews,
      createdBy: createdBy,
    );
  }

  MovieModel get copy {
    return MovieModel(
      id: id,
      title: title,
      description: description,
      imgUrl: imgUrl,
      releaseDate: releaseDate,
      directorName: directorName,
      reviews: reviews,
      createdBy: createdBy,
    );
  }

  @override
  bool get stringify => true;
}
