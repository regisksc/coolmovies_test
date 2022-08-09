// ignore_for_file: leading_newlines_in_multiline_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../../../providers/providers.dart';
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
      child: Consumer<MoviesProvider>(
        builder: (_, provider, __) {
          final movies = provider.movies;
          return movies.isEmpty
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: [
                    Expanded(
                      flex: 95,
                      child: ListView.separated(
                        itemCount: movies.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, __) =>
                            SizedBox(width: spacing),
                        itemBuilder: (BuildContext context, int index) {
                          final movie = movies[index];
                          return Container(
                            key: const Key('movieTile'),
                            padding: EdgeInsets.symmetric(
                              vertical: context.height * .02,
                            ),
                            margin: EdgeInsets.only(
                              bottom: context.height * .03,
                              left: index == 0 ? spacing : 0,
                              right: index >= movies.length - 1 ? spacing : 0,
                            ),
                            child: MovieListTile(movie),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.width * .2),
                        child: Text(
                          """a problem occured when fetching movies. you might be seeing results from storage.""",
                          style: context.textTheme.labelSmall!.copyWith(
                            color: Colors.redAccent.withOpacity(.4),
                          ),
                        ),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
