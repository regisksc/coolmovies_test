// ignore_for_file: unnecessary_string_escapes, leading_newlines_in_multiline_strings

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

  static String get getAllMovieReviews {
    return """
      query {
        allMovieReviews {
          nodes {
            title
            body
            rating
            movieByMovieId {
              id
              title
              userByUserCreatorId {
                id
                name
              }
            }
            commentsByMovieReviewId {
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
      }""";
  }

  // ##

  static String getReview({required String id}) {
    return """
      query {
        movieReviewById(id: \"$id\") {
          body
          id
          movieByMovieId {
            id
            releaseDate
            title
            movieDirectorByMovieDirectorId {
              age
              id
              name
            }
          }
          rating
          nodeId
          title
          userByUserReviewerId {
            name
            id
          }
        }
      } """;
  }

  // ##

  static String getReviews({required String movieId}) {
    return """ 
      query {
        allMovieReviews(
        filter: {movieId: {equalTo: \"$movieId\"}}
      ) {
        nodes {
          title
          body
          rating
          movieByMovieId {
            title
          }
        }
      }
      }
    """;
  }

  // ##

  static String getUsers({int page = 1}) {
    late final int offset;
    if (page == 1) offset = 0;
    if (page != 1) offset = 3 * page;
    return """
      query {
        allUsers(first: 3, offset: $offset) {
          nodes {
          id
          name
          commentsByUserId {
            totalCount,
            nodes {
                movieReviewId
                id
                title
                body
              }
            }
          }
          pageInfo {
            hasNextPage
            hasPreviousPage
          }
        }
      }
  """;
  }

  // ##

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
