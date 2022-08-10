import 'package:coolmovies/core/graphql/graphql_mutations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'createUser query should contain input value',
    () async {
      const input = 'Heather';
      expect(
          GQLMutations.createUser(userName: input), contains(input.toString()));
    },
  );

  test(
    'createMovieReview query should contain input value',
    () async {
      final input = {
        "title": "Test",
        "body": "Lorem Ipsum Text",
        "rating": 4,
        "movieId": "70351289-8756-4101-bf9a-37fc8c7a82cd",
        "userReviewerId": "5f1e6707-7c3a-4acd-b11f-fd96096abd5a"
      };
      expect(
        GQLMutations.createMovieReview(movieReviewMap: input),
        allOf([
          contains('"${input['title']}"'),
          contains('"${input['body']}"'),
          contains('${input['movieId']}'),
          contains('"${input['userReviewerId']}"'),
        ]),
      );
    },
  );
  test(
    'createComment query should contain input value',
    () async {
      final input = {
        "id": "id",
        "title": "Test",
        "body": "Lorem Ipsum Text",
        "rating": 4,
        "movieId": "70351289-8756-4101-bf9a-37fc8c7a82cd",
        "userReviewerId": "5f1e6707-7c3a-4acd-b11f-fd96096abd5a"
      };
      expect(
        GQLMutations.createMovieReview(movieReviewMap: input),
        allOf([
          contains('"${input['title']}"'),
          contains('"${input['body']}"'),
          contains('${input['movieId']}'),
          contains('"${input['movieId']}"'),
          contains('"${input['userReviewerId']}"'),
        ]),
      );
    },
  );
}
