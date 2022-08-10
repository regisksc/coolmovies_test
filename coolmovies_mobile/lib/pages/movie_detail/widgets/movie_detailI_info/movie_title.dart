import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class MovieTitle extends StatefulWidget {
  const MovieTitle(this.movie, {Key? key}) : super(key: key);

  final MovieModel movie;

  @override
  State<MovieTitle> createState() => _MovieTitleState();
}

class _MovieTitleState extends State<MovieTitle> {
  bool canTriggerHeaderAnim = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(microseconds: 10), () {
      setState(() => canTriggerHeaderAnim = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: canTriggerHeaderAnim ? 1 : 0,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.width * .02),
        child: Column(
          children: [
            Hero(
              tag: "${widget.movie.id}-${widget.movie.title}",
              child: Text(
                widget.movie.title,
                textAlign: TextAlign.left,
                style: context.textTheme.headlineLarge!.copyWith(
                  fontSize: context.textTheme.headlineLarge!.fontSize! *
                      (context.screenIsSmall ? .8 : 1),
                  color: Colors.blueGrey.shade900
                      .withOpacity(canTriggerHeaderAnim ? 1 : 0),
                ),
              ),
            ),
            DefaultTextStyle(
              style: context.textTheme.bodySmall!.copyWith(
                color: Colors.blueGrey.shade800,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.movie.formattedReleaseDate,
                    style: TextStyle(
                      fontSize: context.textTheme.bodySmall!.fontSize! *
                          (context.screenIsSmall ? 1 : 1.2),
                    ),
                  ),
                  Text(
                    widget.movie.ratingWStar,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: context.textTheme.bodySmall!.fontSize! * 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
