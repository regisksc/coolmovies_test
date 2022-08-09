import 'package:equatable/equatable.dart';

import '../core.dart';

class MovieReviewModel extends Equatable {
  MovieReviewModel({
    required this.movieId,
    required this.id,
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
      id: json['id'] as String,
      movieId: json['movieId'] as String,
    );
  }

  String get ratingWStar => "⭐ $rating";

  final String id;
  final String movieId;
  String title;
  String body;
  int rating;
  UserModel createdBy;
  bool isInEditState = false;

  MovieReviewModel? reviewBackup;
  void backup() => reviewBackup = copy;

  void discardChanges() {
    if (reviewBackup != null) {
      title = reviewBackup!.title;
      body = reviewBackup!.body;
      rating = reviewBackup!.rating;
    }
  }

  JSON get toJson {
    return {
      "id": id,
      "movieId": movieId,
      "body": body,
      "title": title,
      "rating": rating,
      "userByUserReviewerId": createdBy.toJson,
    };
  }

  @override
  List<Object> get props {
    return [
      id,
      movieId,
      title,
      body,
      rating,
      createdBy,
    ];
  }

  MovieReviewModel copyWith({String? id}) {
    return MovieReviewModel(
      id: id ?? this.id,
      title: title,
      body: body,
      rating: rating,
      createdBy: createdBy,
      movieId: movieId,
    );
  }

  MovieReviewModel get copy {
    return MovieReviewModel(
      id: id,
      title: title,
      body: body,
      rating: rating,
      createdBy: createdBy,
      movieId: movieId,
    );
  }

  @override
  bool get stringify => true;
}
