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
      height: context.height * .45,
      padding: EdgeInsets.symmetric(horizontal: context.width * .02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MovieTitle(movie),
          HighlightedInfos(movie),
          Expanded(child: DescriptionBox(movie))
        ],
      ),
    );
  }
}
