import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../list_movies.dart';

class MoviesList extends StatelessWidget {
  const MoviesList({
    Key? key,
    required this.movies,
  }) : super(key: key);

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    final spacing = context.width * .1;
    return SizedBox(
      width: context.width,
      height: context.height * .6,
      child: ListView.separated(
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, __) => SizedBox(width: spacing),
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: context.height * .02),
            margin: EdgeInsets.only(
                bottom: context.height * .03,
                left: index == 0 ? spacing : 0,
                right: index >= movies.length - 1 ? spacing : 0),
            child: MovieListTile(movie),
          );
        },
      ),
    );
  }
}
