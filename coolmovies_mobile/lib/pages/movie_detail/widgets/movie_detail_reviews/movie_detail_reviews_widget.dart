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
      padding: EdgeInsets.symmetric(horizontal: context.width * .02),
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(
          left: context.width * .02,
          top: context.height * .01,
        ),
        child: SectionWidget(
          title: 'Reviews',
          trailing: AddReviewButton(movie: movie),
          child: Consumer<MoviesProvider>(
            builder: (_, provider, __) {
              return Column(
                children: movie.reviews
                    .map((review) => Padding(
                          padding:
                              EdgeInsets.only(bottom: context.height * .03),
                          child: ReviewTile(
                            review: review,
                            provider: context.read<MoviesProvider>(),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
