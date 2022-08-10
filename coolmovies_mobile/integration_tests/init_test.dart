import 'package:coolmovies/main.dart' as app;
import 'package:coolmovies/pages/pages.dart';
import 'package:coolmovies/providers/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';

import '../test/test_helpers/mock_classes.dart';
import '../test/test_helpers/setup_methods.dart';

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
        when(() => navigator.push(any())).thenAnswer((_) async => null);
        setupListMovieScreenProviders(userProvider, moviesProvider);

        await pumpInit(tester, userProvider, moviesProvider, navigator);
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
