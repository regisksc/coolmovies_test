import 'package:flutter/material.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/core.dart';
import 'movie_list_tile.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final movieImageSize = width;
    return GestureDetector(
      onTap: () => navigator.pushNamed(AppRoutes.movie, arguments: movie),
      child: Container(
        height: movieImageSize * (context.screenIsSmall ? 1.1 : 1.35),
        width: movieImageSize,
        margin: EdgeInsets.only(top: context.height * .19),
        decoration: BoxDecoration(
          color: const Color(0xfffdfdfd),
          borderRadius: defaultRadius,
        ),
        child: Card(
          elevation: 10,
          shadowColor: Colors.grey.shade700,
          shape: RoundedRectangleBorder(borderRadius: defaultRadius),
          child: Stack(
            children: [
              MovieListTileBackground(movie, movieImageSize),
              MovieListTileForeground(movie),
            ],
          ),
        ),
      ),
    );
  }
}
