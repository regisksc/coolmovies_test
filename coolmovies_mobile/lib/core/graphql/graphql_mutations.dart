// ignore_for_file: leading_newlines_in_multiline_strings
import '../core.dart';

class GQLMutations {
  GQLMutations._();

  static String createComment({required JSON commentMap}) {
    return """
      mutation {
        createComment(input: {comment: $commentMap}) {
          comment {
            id
            title
            body
            userByUserId {
              id
              name
            }
            movieReviewByMovieReviewId {
              id
              title
              movieByMovieId {
                title
              }
            }
          }
        }
      }
  """;
  }

  // ##

  static String createMovieReview({
    required JSON movieReviewMap,
  }) {
    return """
      
mutation {
  createMovieReview(input: { 
		movieReview: {
      movieReview: $movieReviewMap
	}
}) {
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
	updateMovieReviewById (input: $movieReviewMap) {

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
    required JSON userMap,
  }) {
    return """"
      mutation {
        createUser(input: {user: $userMap}) {
        user {
          id
          name
        }
      }
      }
  """;
  }
}
