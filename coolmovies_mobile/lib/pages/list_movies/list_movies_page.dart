import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/core.dart';
import '../../repositories/repositories.dart';
import 'list_movies.dart';

class ListMoviesPage extends StatefulWidget {
  const ListMoviesPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ListMoviesPage> createState() => _ListMoviesPageState();
}

class _ListMoviesPageState extends State<ListMoviesPage> {
  final ValueNotifier<List<MovieModel>> _movies = ValueNotifier([]);

  Future _fetchData() async {
    debugPrint('Fetching data...');
    final client = GraphQLProvider.of(context).value;
    final repository = ConcreteMovieRepository(
      client,
      AdaptedFlutterSecureStorage(const FlutterSecureStorage()),
    );
    final result = await repository.getAllMovies();
    result.fold(
      (left) => null,
      (movies) => _movies.value = [...movies, ...movies],
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchData();

    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: _movies,
          builder: (context, _, child) {
            return MoviesList(
              movies: _movies.value,
            );
          },
        ),
      ),
    );
  }
}
