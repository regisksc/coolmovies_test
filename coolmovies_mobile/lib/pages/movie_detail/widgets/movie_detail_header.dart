import 'package:flutter/material.dart';

import '../../../core/core.dart';

class MovieDetailHeader extends StatelessWidget {
  const MovieDetailHeader(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: movie.id,
      child: SizedBox(
        width: context.width,
        child: Image.network(
          movie.imgUrl!,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
