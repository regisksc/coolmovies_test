import '../core.dart';

class MovieReviewCommentModel {
  MovieReviewCommentModel({
    required this.movieReviewId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory MovieReviewCommentModel.fromJson(JSON json) {
    return MovieReviewCommentModel(
      title: json['title'] as String,
      body: json['body'] as String,
      id: json['id'] as String,
      movieReviewId: json['movieReviewId'] as String,
    );
  }

  final String movieReviewId;
  final String id;
  final String title;
  final String body;

  JSON get toJson {
    return {
      "id": id,
      "movieReviewId": movieReviewId,
      "title": title,
      "body": body,
    };
  }
}
