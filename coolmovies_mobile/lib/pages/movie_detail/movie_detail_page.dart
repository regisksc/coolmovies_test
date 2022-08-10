import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/core.dart';
import '../../providers/movie_provider.dart';
import 'movie_detail.dart';
import 'widgets/widgets.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({Key? key, required this.provider}) : super(key: key);
  final MoviesProvider provider;
  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieModel movie;
  late ScrollController scrollController;
  late bool userPassedReviews;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    userPassedReviews = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movie = ModalRoute.of(context)!.settings.arguments! as MovieModel;
    widget.provider.getReviewsForMovieId(movie.id);
    widget.provider.currentMovieId = movie.id;
    scrollController.addListener(() {
      setState(() {
        final pos = scrollController.position;
        if (pos.atEdge && pos.pixels != 0) {
          widget.provider.getReviewsForMovieId(movie.id);
        }
        if (scrollController.position.pixels >=
            (context.height * (context.screenIsSmall ? .8 : .45))) {
          userPassedReviews = true;
        } else {
          userPassedReviews = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final provider = context.read<MoviesProvider>();
        provider.resetEditState();
        provider.resetFetchingReviewState();
        provider.lastFetchedPage = 0;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: CustomScrollView(
          controller: scrollController,
          shrinkWrap: true,
          slivers: [
            SliverAppBar(
              expandedHeight: context.height * .50,
              leading: BackToListButton(movie: movie),
              leadingWidth: context.width * .28,
              pinned: true,
              title: _PageTitle(movie, userPassedReviews: userPassedReviews),
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

class _PageTitle extends StatelessWidget {
  const _PageTitle(
    this.movie, {
    required this.userPassedReviews,
    Key? key,
  }) : super(key: key);

  final bool userPassedReviews;
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: context.width * .2,
        left: context.width * .08,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: userPassedReviews ? 1 : 0,
        child: AutoSizeText(
          movie.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blueGrey[50]),
        ),
      ),
    );
  }
}
