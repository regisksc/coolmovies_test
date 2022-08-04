import '../core.dart';

abstract class StorageAdapter {
  Future<JSON> read(String key);
  Future write(String key, dynamic value);
}
