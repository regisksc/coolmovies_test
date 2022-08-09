import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/core.dart';
import '../../../../../../providers/movie_provider.dart';

class ReviewBody extends StatelessWidget {
  const ReviewBody(
    this.review, {
    Key? key,
  }) : super(key: key);

  final MovieReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width * .05),
            child: Align(
              alignment: Alignment.topLeft,
              child: Consumer<MoviesProvider>(
                builder: (_, provider, __) {
                  return review.isInEditState
                      ? TextFormField(
                          initialValue: review.body,
                          maxLines: 10,
                          onChanged: (editValue) => review.body = editValue,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'tell your opinion',
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          review.body,
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: Colors.blueGrey.shade600,
                          ),
                        );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
