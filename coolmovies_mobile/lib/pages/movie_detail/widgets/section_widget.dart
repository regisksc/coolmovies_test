import 'package:flutter/material.dart';

import '../../../core/core.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * .02,
      ).copyWith(top: context.height * .01),
      child: Column(
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
      ),
    );
  }
}
