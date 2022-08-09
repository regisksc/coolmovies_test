import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/core.dart';
import '../providers/providers.dart';
import '../repositories/repositories.dart';
import 'app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp(
    this.graphql, {
    Key? key,
  }) : super(key: key);

  final GraphQLClient graphql;

  static const title = 'Coolmovies';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      key: const Key('globalProvider'),
      providers: [
        Provider<StorageAdapter>(
          create: (context) {
            const storage = FlutterSecureStorage();
            return AdaptedFlutterSecureStorage(storage);
          },
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (context) {
            final repository = ConcreteUserRepository(
              graphql,
              context.read<StorageAdapter>(),
            );
            return UserProvider(repository)..getCurrentUser();
          },
        ),
        ChangeNotifierProvider<MoviesProvider>(
          create: (context) {
            final repository = ConcreteMovieRepository(
              graphql,
              context.read<StorageAdapter>(),
            );
            return MoviesProvider(repository)..getMovies();
          },
        ),
      ],
      child: MaterialApp(
        title: MyApp.title,
        debugShowCheckedModeBanner: false,
        builder: (context, widget) {
          final theme = context.theme;
          final nunitoFF = GoogleFonts.nunito().fontFamily;
          final rubikFF = GoogleFonts.rubik().fontFamily;
          final mulishFF = GoogleFonts.mulish().fontFamily;
          final tt = theme.textTheme;
          final textTheme = tt.copyWith(
            labelLarge: tt.bodyLarge!.copyWith(
              fontFamily: nunitoFF,
              fontSize: tt.bodyLarge!.fontSize! *
                  MediaQuery.of(context).size.shortestSide *
                  .0025,
            ),
            labelMedium: tt.labelMedium!.copyWith(fontFamily: nunitoFF),
            labelSmall: tt.labelSmall!.copyWith(fontFamily: nunitoFF),
            headlineSmall: tt.headlineSmall!.copyWith(
              fontFamily: rubikFF,
              fontSize: MediaQuery.of(context).size.shortestSide * .03,
              fontWeight: FontWeight.w600,
            ),
            headlineMedium: tt.headlineMedium!.copyWith(
              fontFamily: rubikFF,
              fontSize: MediaQuery.of(context).size.shortestSide * .07,
            ),
            headlineLarge: tt.headlineLarge!.copyWith(fontFamily: rubikFF),
            bodySmall: tt.bodySmall!.copyWith(fontFamily: mulishFF),
            bodyMedium: tt.bodyMedium!.copyWith(fontFamily: mulishFF),
            bodyLarge: tt.bodyLarge!.copyWith(fontFamily: mulishFF),
          );
          return Theme(
            data: theme.copyWith(textTheme: textTheme),
            child: ResponsiveWrapper.builder(
              ClampingScrollWrapper.builder(context, widget!),
              breakpoints: const [
                ResponsiveBreakpoint.resize(350, name: MOBILE),
                ResponsiveBreakpoint.autoScale(600, name: TABLET),
              ],
            ),
          );
        },
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initialRoute,
      ),
    );
  }
}
