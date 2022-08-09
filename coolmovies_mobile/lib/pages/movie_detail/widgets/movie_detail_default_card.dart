import 'package:flutter/material.dart';

import '../../../core/core.dart';

class DefaultMovieInfoCard extends StatelessWidget {
  const DefaultMovieInfoCard({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[50],
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
      child: child,
    );
  }
}
