import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MovieListTileForeground extends StatelessWidget {
  const MovieListTileForeground(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final height = context.heightAdjusted;
    final width = context.width;
    final textTheme = context.textTheme;
    return Positioned(
      bottom: 0,
      child: Container(
        height: height * .08,
        width: width * .75,
        padding: EdgeInsets.only(bottom: height * .01),
        alignment: Alignment.bottomLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "${movie.id}-${movie.title}",
                      child: Text(
                        movie.title,
                        style: textTheme.labelMedium!.copyWith(
                          color: Colors.black,
                          fontSize: height * .018,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      movie.releaseYear.isNotEmpty
                          ? "(${movie.releaseYear})"
                          : "",
                      style: textTheme.caption!.copyWith(
                        color: Colors.black,
                        fontSize: height * .015,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.only(bottom: 5),
                child: () {
                  return Text(
                    movie.ratingWStar,
                    style: textTheme.labelLarge!
                        .copyWith(fontSize: height * .015 * 1.8),
                  );
                }(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
