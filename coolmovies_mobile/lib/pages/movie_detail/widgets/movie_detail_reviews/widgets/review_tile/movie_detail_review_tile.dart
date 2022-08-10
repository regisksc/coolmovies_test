import 'package:flutter/material.dart';

import '../../../../../../core/core.dart';
import '../../../../../../providers/movie_provider.dart';
import '../../../../movie_detail.dart';

class ReviewTile extends StatefulWidget {
  const ReviewTile({
    Key? key,
    required this.review,
    required this.provider,
  }) : super(key: key);

  final MovieReviewModel review;
  final MoviesProvider provider;

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool tileLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 1), () {
      setState(() => tileLoaded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: tileLoaded ? 1 : 0,
      child: AnimatedContainer(
        alignment: Alignment.centerLeft,
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(left: tileLoaded ? context.width * .05 : 0),
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.blueGrey[50],
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: defaultRadius),
          child: Container(
            width: context.width * .90,
            padding: const EdgeInsets.all(5),
            height: context.height * (context.screenIsSmall ? .35 : .3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 12,
                  child: _ReviewerRow(
                    widget.provider,
                    review: widget.review,
                  ),
                ),
                Expanded(
                  flex: 88,
                  child: _ReviewContent(
                    widget.provider,
                    review: widget.review,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewerRow extends StatelessWidget {
  const _ReviewerRow(
    this.provider, {
    Key? key,
    required this.review,
  }) : super(key: key);

  final MoviesProvider provider;
  final MovieReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "${review.createdBy.name}'${review.createdBy.name.endsWith('s') ? '' : 's'} opinion:",
            style: context.textTheme.bodyMedium!.copyWith(
              color: Colors.blueGrey.shade600,
            ),
          ),
        ),
        Expanded(child: ReviewEditButton(review)),
      ],
    );
  }
}

class _ReviewContent extends StatelessWidget {
  const _ReviewContent(
    this.provider, {
    Key? key,
    required this.review,
  }) : super(key: key);

  final MoviesProvider provider;
  final MovieReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: defaultRadius.copyWith(
          topLeft: Radius.zero,
          topRight: Radius.zero,
        ),
      ),
      child: Column(
        children: [
          const Spacer(flex: 3),
          Expanded(flex: 17, child: ReviewHeader(review)),
          const Spacer(flex: 2),
          Expanded(flex: 78, child: ReviewBody(review)),
        ],
      ),
    );
  }
}
