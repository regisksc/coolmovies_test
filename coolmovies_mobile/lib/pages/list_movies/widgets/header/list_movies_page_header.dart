import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/core.dart';
import '../../../../providers/providers.dart';

class ListMoviesPageHeader extends StatelessWidget {
  const ListMoviesPageHeader({
    Key? key,
    required this.userProvider,
  }) : super(key: key);

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    final greetingFont = context.textTheme.headlineMedium!.copyWith(
      fontSize: context.textTheme.headlineMedium!.fontSize! * .7,
      color: Colors.grey.shade400,
    );
    final highlightedGreetingFont = greetingFont.copyWith(
      color: Colors.grey.shade200,
      fontSize: greetingFont.fontSize! * 1.25,
      fontWeight: FontWeight.bold,
    );
    return Card(
      elevation: 20,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
      child: Container(
        height: context.height * .18,
        width: context.width * .7,
        padding: const EdgeInsets.symmetric(vertical: 10).copyWith(right: 10),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: defaultRadius.copyWith(
            bottomLeft: Radius.zero,
            topLeft: Radius.zero,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.width * .05,
                vertical: context.height * .03,
              ),
              child: Consumer<UserProvider?>(
                builder: (_, userProvider, __) {
                  return RichText(
                    text: TextSpan(
                      text: 'Hello ',
                      style: greetingFont,
                      children: [
                        TextSpan(
                          text: userProvider?.user?.name ?? '',
                          style: highlightedGreetingFont,
                        ),
                        TextSpan(
                          text: " !",
                          style: greetingFont,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                const Spacer(flex: 35),
                Expanded(
                  flex: 65,
                  child: Text(
                    'looking for a movie?',
                    textAlign: TextAlign.right,
                    style: context.textTheme.headlineSmall!.copyWith(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
