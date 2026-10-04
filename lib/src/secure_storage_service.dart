import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'key_value_store.dart';

/// A [KeyValueStore] backed by [FlutterSecureStorage].
///
/// Platform errors, such as a missing plugin or a locked keychain, are
/// swallowed: reads return `null` and writes, deletes, and clear operations
/// become no-ops. This matches the tolerant behavior of the original app
/// storage helper while also handling asynchronous platform failures.
///
/// iOS items are stored with [KeychainAccessibility.first_unlock]. Android
/// uses the plugin defaults; `flutter_secure_storage` 11.x always encrypts
/// stored data, so the legacy `encryptedSharedPreferences` flag no longer
/// exists.
class SecureStorageService implements KeyValueStore {
  /// Creates a service around [storage].
  ///
  /// When [storage] is omitted, a default [FlutterSecureStorage] instance is
  /// created.
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static const AndroidOptions _androidOptions = AndroidOptions();

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(
        key: key,
        iOptions: _iosOptions,
        aOptions: _androidOptions,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: _iosOptions,
        aOptions: _androidOptions,
      );
    } catch (_) {}
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(
        key: key,
        iOptions: _iosOptions,
        aOptions: _androidOptions,
      );
    } catch (_) {}
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        iOptions: _iosOptions,
        aOptions: _androidOptions,
      );
    } catch (_) {}
  }
}
