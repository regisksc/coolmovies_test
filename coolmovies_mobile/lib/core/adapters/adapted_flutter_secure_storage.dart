import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core.dart';

class AdaptedFlutterSecureStorage implements StorageAdapter {
  AdaptedFlutterSecureStorage(this.storage);
  final FlutterSecureStorage storage;

  @override
  Future<JSON> read(String key) async {
    final readValue = await storage.read(key: key);
    if (readValue == null) return {};
    return jsonDecode(readValue) as JSON;
  }

  @override
  Future write(String key, dynamic value) async {
    return storage.write(key: key, value: jsonEncode(value));
  }
}
