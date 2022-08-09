import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../providers/providers.dart';
import 'list_movies.dart';

class ListMoviesPage extends StatefulWidget {
  const ListMoviesPage({
    Key? key,
    required UserProvider userProvider,
    required MoviesProvider moviesProvider,
  })  : _userProvider = userProvider,
        _moviesProvider = moviesProvider,
        super(key: key);

  final UserProvider _userProvider;
  final MoviesProvider _moviesProvider;
  @override
  State<ListMoviesPage> createState() => _ListMoviesPageState();
}

class _ListMoviesPageState extends State<ListMoviesPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.height * .03),
            ListMoviesPageHeader(userProvider: widget._userProvider),
            SizedBox(height: context.height * .03),
            MoviesList(movies: widget._moviesProvider.movies),
          ],
        ),
      ),
    );
  }
}
