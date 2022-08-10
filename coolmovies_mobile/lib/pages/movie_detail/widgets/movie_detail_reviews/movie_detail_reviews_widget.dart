import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../../../providers/movie_provider.dart';
import '../../../pages.dart';

class MovieDetailReviews extends StatelessWidget {
  const MovieDetailReviews(
    this.movie, {
    Key? key,
  }) : super(key: key);
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Column(
        children: [
          SectionTitle(
            title: 'Reviews',
            trailing: AddReviewButton(movie: movie),
          ),
          Consumer<MoviesProvider>(
            builder: (_, provider, __) {
              final reviews = provider.reviews[movie.id] ?? [];
              return Column(
                children: [
                  ...reviews
                      .map((review) => Padding(
                            padding:
                                EdgeInsets.only(bottom: context.height * .03),
                            child: ReviewTile(
                              review: review,
                              provider: context.read<MoviesProvider>(),
                            ),
                          ))
                      .toList(),
                  Visibility(
                    visible: provider.isLoadingMoreReviews,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: context.height * .1),
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
