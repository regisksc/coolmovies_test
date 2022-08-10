import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import 'movie_detailI_info.dart';

class MovieDetailInfo extends StatelessWidget {
  const MovieDetailInfo(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height * (context.screenIsSmall ? .4 : .3),
      padding: EdgeInsets.symmetric(horizontal: context.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [MovieTitle(movie), DescriptionBox(movie)],
      ),
    );
  }
}

class DescriptionBox extends StatelessWidget {
  const DescriptionBox(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: context.width * .02,
        top: context.height * .01,
      ),
      child: Text(
        movie.description ?? "",
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        style: context.textTheme.bodyMedium!.copyWith(
            fontSize: context.textTheme.bodyMedium!.fontSize! *
                (context.screenIsSmall ? 1 : 1.2)),
      ),
    );
  }
}
