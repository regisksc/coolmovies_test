import '../core.dart';

class MovieReviewModel {
  MovieReviewModel({
    required this.title,
    required this.body,
    required this.rating,
    required this.createdBy,
  });

  factory MovieReviewModel.fromJson(JSON json) {
    return MovieReviewModel(
      title: json['title'] as String,
      body: json['body'] as String,
      rating: json['rating'] as int,
      createdBy: UserModel.fromJson(
        json["userByUserReviewerId"] as JSON,
      ),
    );
  }

  final String title;
  final String body;
  final int rating;
  final UserModel createdBy;

  JSON get toJson {
    return {
      "body": body,
      "title": title,
      "rating": rating,
      "userByUserReviewerId": createdBy,
    };
  }
}
