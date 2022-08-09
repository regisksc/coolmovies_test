import 'package:flutter/cupertino.dart';

import '../core/core.dart';

abstract class DefaultProvider extends ChangeNotifier {
  Failure? lastRequestFailure;
}
