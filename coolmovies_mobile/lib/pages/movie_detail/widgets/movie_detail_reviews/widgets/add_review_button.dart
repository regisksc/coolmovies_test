import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/core.dart';
import '../../../../../providers/providers.dart';

class AddReviewButton extends StatelessWidget {
  const AddReviewButton({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => context.read<MoviesProvider>().addReview(
              user: context.read<UserProvider>().user!,
            ),
        icon: const Icon(
          Icons.add_box_rounded,
          color: Colors.black26,
        ),
      ),
    );
  }
}
