import 'package:flutter/material.dart';

import '../../../core/core.dart';

class SectionWidget extends StatelessWidget {
  const SectionWidget({
    Key? key,
    required this.title,
    required this.child,
    this.trailing,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: title, trailing: trailing),
        child,
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    this.trailing,
  }) : super(key: key);

  final Widget? trailing;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            Text(title, style: context.textTheme.headlineMedium),
            const Spacer(flex: 20),
            trailing ?? const SizedBox(),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
