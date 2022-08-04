import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../core.dart';

void jsonLogger(JSON json) {
  final object = jsonDecode(jsonEncode(json));
  final prettyJson = const JsonEncoder.withIndent('  ').convert(object);
  debugPrint("##############\n");
  debugPrint(prettyJson);
  debugPrint("##############\n");
}
