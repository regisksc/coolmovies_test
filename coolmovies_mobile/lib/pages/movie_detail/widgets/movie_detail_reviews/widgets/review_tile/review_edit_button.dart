import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/core.dart';
import '../../../../../../providers/providers.dart';

class ReviewEditButton extends StatelessWidget {
  const ReviewEditButton(
    this.review, {
    Key? key,
  }) : super(key: key);
  final MovieReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (_, provider, __) {
        final user = context.read<UserProvider>().user!;
        return Visibility(
          visible: user.id == review.createdBy.id,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              _InteractiveButton(
                label: review.isInEditState ? 'save' : 'edit',
                onTap: () => !review.isInEditState
                    ? provider.startEditingReview(review)
                    : provider.stopEditingReview(user, review,
                        shouldSave: true),
                color: !review.isInEditState
                    ? Colors.black12
                    : Colors.greenAccent.withOpacity(.2),
              ),
              Visibility(
                visible: review.isInEditState,
                child: _InteractiveButton(
                  label: 'cancel',
                  onTap: () => provider.stopEditingReview(user, review),
                  color: Colors.redAccent.withOpacity(.2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InteractiveButton extends StatelessWidget {
  const _InteractiveButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.color,
  }) : super(key: key);

  final VoidCallback onTap;
  final String label;
  final Color color;

  bool get _shouldShowIcon => label == 'edit';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Card(
        color: color,
        child: Container(
          height: context.height * .03,
          width: context.width * .15,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: context.textTheme.labelSmall!.copyWith(
                  fontSize: context.width * .028,
                  color: Colors.white60,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(width: context.width * .01),
              Icon(
                Icons.edit,
                color: Colors.white60,
                size: MediaQuery.of(context).size.shortestSide *
                    (_shouldShowIcon ? .03 : 0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
