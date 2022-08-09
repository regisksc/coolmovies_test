import 'package:coolmovies/core/graphql/graphql_mutations.dart';
import 'package:coolmovies/core/graphql/graphql_queries.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'createUser query should contain input value',
    () async {
      final input = {"name": "Heather"};
      expect(
          GQLMutations.createUser(userMap: input), contains(input.toString()));
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
        contains(input.toString()),
      );
    },
  );
  test(
    'createComment query should contain input value',
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
        contains(input.toString()),
      );
    },
  );

  test(
    'getReviews by movieId query should contain input value',
    () async {
      final input = faker.guid.guid();
      expect(
        GQLQueries.getReviews(movieId: input),
        contains(input.toString()),
      );
    },
  );

  test(
    'getReview by id query should contain input value',
    () async {
      final input = faker.guid.guid();
      expect(
        GQLQueries.getReview(id: input),
        contains(input.toString()),
      );
    },
  );

  test(
    'getUsers query should have a 0 offset when input is 1',
    () async {
      const input = 1;
      expect(
        // ignore: avoid_redundant_argument_values
        GQLQueries.getUsers(page: input),
        contains("offset: 0"),
      );
    },
  );

  test(
    'getUsers query should have non 0 offset when input is different than 1',
    () async {
      final input = faker.randomGenerator.integer(10, min: 2);
      expect(
        // ignore: avoid_redundant_argument_values
        GQLQueries.getUsers(page: input),
        contains("offset: ${input * 3}"),
      );
    },
  );
}
