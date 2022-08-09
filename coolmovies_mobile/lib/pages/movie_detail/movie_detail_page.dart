import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../providers/movie_provider.dart';
import 'movie_detail.dart';
import 'widgets/widgets.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments! as MovieModel;
    return WillPopScope(
      onWillPop: () async {
        context.read<MoviesProvider>().resetEditState(movie);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              expandedHeight: context.height * .50,
              leading: BackToListButton(movie: movie),
              leadingWidth: context.width * .28,
              flexibleSpace: FlexibleSpaceBar(
                  background: MovieDetailHeader(movie),
                  stretchModes: const [
                    StretchMode.blurBackground,
                    StretchMode.zoomBackground,
                  ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    MovieDetailInfo(movie),
                    MovieDetailReviews(movie),
                  ],
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
