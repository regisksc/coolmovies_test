import 'package:coolmovies/core/core.dart';
import 'package:faker/faker.dart';

UserModel get mockUserModel => UserModel(
      id: faker.guid.guid(),
      name: faker.person.name(),
      comments: List<MovieReviewCommentModel>.generate(
          3, (_) => mockMovieReviewCommentModel),
    );

MovieModel mockMovieModel({bool makeReleaseDateNull = false}) => MovieModel(
      title: faker.lorem.words(3).join(" "),
      id: faker.guid.guid(),
      imgUrl:
          "https://upload.wikimedia.org/wikipedia/en/d/d4/Rogue_One%2C_A_Star_Wars_Story_poster.png",
      releaseDate: makeReleaseDateNull ? null : mockDate,
      createdBy: mockUserModel,
      directorName: faker.person.name(),
      reviews: List<MovieReviewModel>.generate(3, (_) => mockMovieReviewModel),
    );

MovieReviewCommentModel get mockMovieReviewCommentModel =>
    MovieReviewCommentModel(
      movieReviewId: faker.guid.guid(),
      id: faker.guid.guid(),
      title: faker.lorem.words(3).join(" "),
      body: faker.lorem.sentence(),
    );

MovieReviewModel get mockMovieReviewModel => MovieReviewModel(
      title: faker.lorem.words(3).join(" "),
      body: faker.lorem.sentence(),
      rating: faker.randomGenerator.integer(5, min: 1),
      createdBy: mockUserModel,
    );

String get mockDate =>
    "${faker.randomGenerator.integer(2022, min: 1900)}-${faker.randomGenerator.integer(12, min: 1)}-${faker.randomGenerator.integer(31, min: 1)}";
