import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
import '../providers/providers.dart';

class AppRoutes {
  AppRoutes._();

  static const String initialRoute = home;

  static const String home = '/';
  static const String movie = '/movie';

  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      AppRoutes.home: (context) => ListMoviesPage(
            userProvider: context.read<UserProvider>(),
            moviesProvider: context.read<MoviesProvider>(),
          ),
      AppRoutes.movie: (context) => const MovieDetailPage(),
    };
  }
}
