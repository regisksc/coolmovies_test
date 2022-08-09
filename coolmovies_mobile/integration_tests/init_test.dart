import 'package:coolmovies/core/core.dart';
import 'package:coolmovies/main.dart' as app;
import 'package:coolmovies/pages/pages.dart';
import 'package:coolmovies/providers/providers.dart';
import 'package:coolmovies/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';

import '../test/core/adapters/adapted_flutter_secure_storage_test.dart';
import '../test/test_helpers/mock_objects.dart';

class MockUserProvider extends Mock implements UserProvider {}

class MockMoviesProvider extends Mock implements MoviesProvider {}

class MockUserRepository extends Mock implements UserRepository {}

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late UserProvider userProvider;
  late MoviesProvider moviesProvider;

  setUp(() {
    userProvider = MockUserProvider();
    moviesProvider = MockMoviesProvider();
  });

  tearDown(() {
    userProvider.dispose();
    moviesProvider.dispose();
  });

  testWidgets(
    '''
    WHEN app launches
    SHOULD show ListMoviesPage
    SHOULD have provider fetch current user
    SHOULD have provider fetch movies from repository
    SHOULD render its widgets
    ''',
    (tester) async {
      await mockNetworkImages(() async {
        app.main();

        final navigator = MockNavigator();
        final user = mockUserModel;
        final movies = mockMovieList();
        when(() => navigator.push(any())).thenAnswer((_) async => null);
        when(() => userProvider.user).thenReturn(user);

        when(() => moviesProvider.movies).thenReturn(movies);
        when(() => moviesProvider.getMovies())
            .thenAnswer((_) => Future.value());
        when(() => userProvider.getCurrentUser())
            .thenAnswer((_) => Future.value());

        await _pumpInit(tester, userProvider, moviesProvider, navigator);
        await tester.pumpAndSettle();

        final multiProvider = find.byType(MultiProvider);
        expect(multiProvider, findsOneWidget);

        final page = find.byType(ListMoviesPage);
        expect(page, findsOneWidget);

        final pageHeader = find.byType(ListMoviesPageHeader);
        expect(pageHeader, findsOneWidget);

        final moviesList = find.byType(MoviesList);
        expect(moviesList, findsOneWidget);
      });
    },
  );
}

Future<void> _pumpInit(
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
