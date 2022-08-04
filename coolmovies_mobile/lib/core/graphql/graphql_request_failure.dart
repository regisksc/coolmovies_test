import 'package:flutter/rendering.dart';

import '../core.dart';

class GQLRequestFailure<T> extends Failure {
  GQLRequestFailure(String rawMessage, {this.valuesFromStorage})
      : super(
            message: "Oops... An error occured when processing your request") {
    debugPrint("EXCEPTION: $rawMessage");
  }

  final T? valuesFromStorage;
}
