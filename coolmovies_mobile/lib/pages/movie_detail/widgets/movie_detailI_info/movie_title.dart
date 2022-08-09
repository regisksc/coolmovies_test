import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MovieTitle extends StatelessWidget {
  const MovieTitle(this.movie, {Key? key}) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.width * .02),
      child: Hero(
        tag: "${movie.id}-${movie.title}",
        child: Text(
          movie.title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineLarge!.copyWith(
            color: Colors.blueGrey.shade800,
          ),
        ),
      ),
    );
  }
}
