import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../movie_detail.dart';

class DescriptionBox extends StatelessWidget {
  const DescriptionBox(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.width * .02,
        top: context.height * .01,
      ),
      child: SectionWidget(
        title: 'Description',
        child: DefaultMovieInfoCard(
          child: Container(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.shortestSide * .02,
            ),
            child: Text(
              movie.description ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
