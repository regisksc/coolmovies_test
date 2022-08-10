// ignore_for_file: unnecessary_string_escapes

import '../core.dart';

class GQLMutations {
  GQLMutations._();

  static String createMovieReview({
    required JSON movieReviewMap,
  }) {
    return """
      

mutation {
  createMovieReview(
    input: { 
      movieReview: {
        title: \"${movieReviewMap['title']}\",
        body: \"${movieReviewMap['body']}\",
        rating: ${movieReviewMap['rating']},
        movieId: \"${movieReviewMap['movieId']}\",
        userReviewerId: \"${movieReviewMap['userReviewerId']}\"
      }}) {
    movieReview {
      id
      movieByMovieId {
        title
      }
      userByUserReviewerId {
        name
      }
    }
  }
}
  """;
  }

  // ##
// ##

  static String updateMovieReview({
    required JSON movieReviewMap,
  }) {
    return """
      
mutation {
	updateMovieReviewById (input: {
	id: \"${movieReviewMap['id']}\",movieReviewPatch: {title: \"${movieReviewMap['title']}\",
      body: \"${movieReviewMap['body']}\",
      rating: ${movieReviewMap['rating']},
      movieId: \"${movieReviewMap['movieId']}\",
      userReviewerId: \"${movieReviewMap['userReviewerId']}\"
      
    }}) {

		movieReview {
			id
			movieId
			title
			body
			rating
			userReviewerId
		}
	}
}
  """;
  }

  // ##

  static String createUser({
    required String userName,
  }) {
    return """
      mutation {
        createUser(input: {user: {name: $userName}}) {
        user {
          id
          name
        }
      }
      }
  """;
  }
}
