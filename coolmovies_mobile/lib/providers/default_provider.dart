import 'package:flutter/cupertino.dart';

import '../core/core.dart';

abstract class DefaultProvider extends ChangeNotifier {
  // * tech debt: think of a better way of handling failures without bloc in this case
  Failure? lastRequestFailure;
}
