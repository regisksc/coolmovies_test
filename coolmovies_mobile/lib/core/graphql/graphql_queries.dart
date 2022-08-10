// ignore_for_file: unnecessary_string_escapes, leading_newlines_in_multiline_strings

import '../core.dart';

class GQLQueries {
  GQLQueries._();

  static String get getAllMovies => """
          query AllMovies {
            allMovies {
              nodes {
                id
                imgUrl
                title
                releaseDate
								movieDirectorByMovieDirectorId {
									id
									name
								}
								movieReviewsByMovieId{
									totalCount
									nodes {
										id
                    movieId
										body
										title
										rating
										userByUserReviewerId {
											id
											name
											commentsByUserId {
												totalCount
												nodes {
													id
													userId
													body
													title
												}
											}
										}
									}
								}
                userByUserCreatorId {
                  id
                  name
									commentsByUserId {
										nodes {
											movieReviewId
											id
											title
											body
											
										}
									}
                }
              }
						}
}
        """;

  // ##

  static String getReviewsForMovieId(
    String movieId, {
    required int pageNum,
  }) {
    late final int offset;
    if (pageNum == 1) offset = 0;
    if (pageNum != 1) {
      offset = reviewsPerPage * pageNum;
    }
    return """ {
  allMovieReviews(
		first: $reviewsPerPage, offset: $offset
    filter: { movieId: {equalTo: "$movieId"}}
  ) {
    nodes {
				title
				body
				id
				rating
				title
        movieId
				userByUserReviewerId {
					name
					id
					commentsByUserId {
										nodes {
											movieReviewId
											id
											title
											body
											
										}
									}
    	}
    }
  }
} """;
  }

  static String get getCurrentUser {
    return """
      query {
        currentUser {
    id
    name
		commentsByUserId {
			nodes {
				id
          title
          body
          userByUserId {
            id
            name
          }
			}
		}
  }
      }
  """;
  }
}
