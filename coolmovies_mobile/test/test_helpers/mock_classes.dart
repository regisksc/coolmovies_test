import 'package:coolmovies/providers/providers.dart';
import 'package:coolmovies/repositories/repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProvider extends Mock implements UserProvider {}

class MockMoviesProvider extends Mock implements MoviesProvider {}

class MockUserRepository extends Mock implements UserRepository {}

class MockMovieRepository extends Mock implements MovieRepository {}
