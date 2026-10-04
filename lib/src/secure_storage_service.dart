import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'key_value_store.dart';

/// A [KeyValueStore] backed by [FlutterSecureStorage].
///
/// Platform errors, such as a missing plugin or a locked keychain, are
/// swallowed: reads return `null` and writes, deletes, and clear operations
/// become no-ops. This matches the tolerant behavior of the original app
/// storage helper while also handling asynchronous platform failures.
///
/// iOS items are stored with [KeychainAccessibility.first_unlock] and Android
/// uses `AndroidOptions(resetOnError: false)` by default, so undecryptable
/// Android data is preserved instead of being wiped when an error is
/// detected. Both options can be overridden through the constructor and are
/// forwarded on every call.
///
/// `flutter_secure_storage` 11.x cannot read data written by 9.x on Android
/// through EncryptedSharedPreferences; the Android store resets once. This
/// package accepts that one-time reset. On iOS the `first_unlock`
/// accessibility class is unchanged, so existing items remain readable.
class SecureStorageService implements KeyValueStore {
  /// Creates a service around [storage].
  ///
  /// When [storage] is omitted, a default [FlutterSecureStorage] instance is
  /// created. [iOptions] and [aOptions] default to `first_unlock` on iOS and
  /// `resetOnError: false` on Android, and are passed on every platform call.
  SecureStorageService({
    FlutterSecureStorage? storage,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _iOptions =
           iOptions ??
           const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
       _aOptions = aOptions ?? const AndroidOptions(resetOnError: false);

  final FlutterSecureStorage _storage;
  final AppleOptions _iOptions;
  final AndroidOptions _aOptions;

  /// The underlying [FlutterSecureStorage] instance used for platform calls.
  FlutterSecureStorage get storage => _storage;

  @override
  Future<String?> read(String key) async {
    try {
      return await _storage.read(
        key: key,
        iOptions: _iOptions,
        aOptions: _aOptions,
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
        iOptions: _iOptions,
        aOptions: _aOptions,
      );
    } catch (_) {}
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key, iOptions: _iOptions, aOptions: _aOptions);
    } catch (_) {}
  }

  @override
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(iOptions: _iOptions, aOptions: _aOptions);
    } catch (_) {}
  }
}
