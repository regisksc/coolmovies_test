import 'package:equatable/equatable.dart';

import '../core.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    this.comments = const [],
  });
  factory UserModel.fromJson(JSON json) {
    return UserModel(
      name: json['name'] as String,
      id: json['id'] as String,
      comments: (json['commentsByUserId']['nodes'] as List)
          .map((e) => MovieReviewCommentModel.fromJson(e as JSON))
          .toList(),
    );
  }

  final String id;
  final String name;
  final List<MovieReviewCommentModel> comments;

  int get commentCount => comments.length;

  JSON get toJson {
    return {
      "id": id,
      "name": name,
      "commentsByUserId": {
        "nodes": comments.map((comment) => comment.toJson).toList(),
      }
    };
  }

  @override
  List<Object?> get props => [id, name];
}
