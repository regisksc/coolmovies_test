import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MovieListTileBackground extends StatelessWidget {
  const MovieListTileBackground(
    this.movie,
    this.movieImageSize, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;
  final double movieImageSize;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        final shader = Rect.fromLTRB(0, 0, rect.width, rect.height);
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.transparent],
        ).createShader(shader);
      },
      blendMode: BlendMode.dstIn,
      child: ClipRRect(
        borderRadius: defaultRadius,
        child: SizedBox(
          height: context.width,
          child: Hero(
            tag: movie.id,
            child: Image.network(
              movie.imgUrl!,
              fit: BoxFit.fill,
              height: movieImageSize,
              width: movieImageSize,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress?.cumulativeBytesLoaded ==
                    loadingProgress?.expectedTotalBytes) return child;
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
