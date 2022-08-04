import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get heightAdjustFactor => width > 320 ? .87 : 1;
  double get heightAdjusted => height * heightAdjustFactor;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
