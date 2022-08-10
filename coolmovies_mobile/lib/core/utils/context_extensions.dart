import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get heightAdjustFactor => width > 320 ? .87 : 1;
  double get heightAdjusted => height * heightAdjustFactor;
  bool get screenIsSmall => width < 350;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  void get pop {
    final navigator = Navigator.of(this);
    if (navigator.canPop()) navigator.pop();
  }
}
