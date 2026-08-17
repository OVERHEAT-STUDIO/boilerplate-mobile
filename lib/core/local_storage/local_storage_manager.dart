import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_storage_manager.g.dart';

@Riverpod(keepAlive: true)
LocalStorageManager localStorageManager(Ref ref) {
  const secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  return LocalStorageManager(secureStorage);
}

class LocalStorageManager {
  final FlutterSecureStorage _storage;

  LocalStorageManager(this._storage);

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<bool> isKeyExist(String key) async {
    return await _storage.containsKey(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<void> clear({
    bool fullClear = false,
    List<String> ignoredKeys = const [],
  }) async {
    if (fullClear && kDebugMode) {
      await _storage.deleteAll();
      return;
    }
    final entries = await _storage.readAll();
    for (final key in entries.keys) {
      if (!ignoredKeys.contains(key)) {
        await _storage.delete(key: key);
      }
    }
  }
}