import 'package:coolmovies/core/core.dart';
import 'package:coolmovies/pages/list_movies/list_movies_page.dart';
import 'package:coolmovies/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';

import '../core/adapters/adapted_flutter_secure_storage_test.dart';
import 'mock_objects.dart';

void setupListMovieScreenProviders(
    UserProvider userProvider, MoviesProvider moviesProvider) {
  when(() => userProvider.user).thenReturn(mockUserModel);
  when(() => moviesProvider.movies).thenReturn(mockMovieList());
  when(() => moviesProvider.getMovies()).thenAnswer((_) => Future.value());
  when(() => userProvider.getCurrentUser()).thenAnswer((_) => Future.value());
}

Future<void> pumpInit(
  WidgetTester tester,
  UserProvider userProvider,
  MoviesProvider moviesProvider,
  MockNavigator navigator,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<StorageAdapter>(
          create: (context) => AdaptedFlutterSecureStorage(
            MockFlutterSecureStorage(),
          ),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) => userProvider..getCurrentUser(),
        ),
        ChangeNotifierProvider<MoviesProvider>(
          create: (context) => moviesProvider..getMovies(),
        ),
      ],
      child: MaterialApp(
        home: MockNavigatorProvider(
          navigator: navigator,
          child: ListMoviesPage(
            userProvider: userProvider,
            moviesProvider: moviesProvider,
          ),
        ),
      ),
    ),
  );
}
