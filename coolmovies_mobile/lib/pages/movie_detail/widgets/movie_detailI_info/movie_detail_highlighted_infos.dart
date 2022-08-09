import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../../../providers/providers.dart';
import '../../movie_detail.dart';

class HighlightedInfos extends StatelessWidget {
  const HighlightedInfos(
    this.movie, {
    Key? key,
  }) : super(key: key);
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    final hightlightedInformations = [
      {
        "title": "release",
        "value": movie.formattedReleaseDate,
      },
      {
        "title": "director",
        "value": movie.directorName,
      },
      {
        "title": "rated",
        "value": movie.ratingWStar,
      },
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: hightlightedInformations
          .map((e) =>
              HighlightedInfoBlock(title: e["title"]!, value: e["value"]!))
          .toList(),
    );
  }
}

class HighlightedInfoBlock extends StatelessWidget {
  const HighlightedInfoBlock({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final fontMultiplier = value.contains("⭐") ? 1.5 : 1;
    return DefaultTextStyle.merge(
      style: context.textTheme.bodySmall!.copyWith(
        letterSpacing: 1,
        color: Colors.blueGrey.shade600,
      ),
      child: DefaultMovieInfoCard(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: context.height * .02),
          width: context.width * .25,
          height: context.width * .25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 20,
                child: Center(child: Text(title)),
              ),
              const Spacer(flex: 15),
              Expanded(
                flex: 65,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: context.width * .02),
                  alignment: Alignment.center,
                  child: Consumer<MoviesProvider>(
                    builder: (_, provider, __) {
                      return Text(
                        value,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall!.copyWith(
                            color: Colors.blueGrey.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: context.textTheme.bodySmall!.fontSize! *
                                fontMultiplier),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
