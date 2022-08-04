import 'package:intl/intl.dart';

import '../core.dart';

class MovieModel {
  const MovieModel({
    required this.title,
    required this.id,
    required this.createdBy,
    this.reviews = const [],
    this.directorName,
    this.imgUrl,
    this.releaseDate,
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
    );
  }

  final String id;
  final String title;
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

  JSON get toJson {
    return {
      "id": id,
      "imgUrl": imgUrl,
      "title": title,
      "releaseDate": releaseDate,
      "movieDirectorByMovieDirectorId": {"name": directorName},
      "movieReviewsByMovieId": {"nodes": reviews},
      "userByUserCreatorId": createdBy
    };
  }
}
