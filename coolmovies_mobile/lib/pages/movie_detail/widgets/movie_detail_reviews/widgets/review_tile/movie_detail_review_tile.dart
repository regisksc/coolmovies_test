import 'package:flutter/material.dart';

import '../../../../../../core/core.dart';
import '../../../../../../providers/movie_provider.dart';
import '../../../../movie_detail.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
    required this.review,
    required this.provider,
  }) : super(key: key);

  final MovieReviewModel review;
  final MoviesProvider provider;

  @override
  Widget build(BuildContext context) {
    return DefaultMovieInfoCard(
      child: Container(
        padding: const EdgeInsets.all(5),
        height: context.height * .3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 12,
              child: _ReviewerRow(
                provider,
                review: review,
              ),
            ),
            Expanded(
              flex: 88,
              child: _ReviewContent(
                provider,
                review: review,
              ),
            ),
          ],
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
            "${review.createdBy.name}'s opinion:",
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
