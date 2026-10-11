import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'key_value_store.dart';

/// A [KeyValueStore] backed by [FlutterSecureStorage].
///
/// The service swallows platform errors, such as a missing plugin or a locked
/// keychain. Reads return `null`; writes, deletes, and clear operations become
/// no-ops. This behavior matches the tolerant original storage helper and
/// handles asynchronous platform failures.
///
/// The service stores iOS items with [KeychainAccessibility.first_unlock]. On
/// Android, the default `AndroidOptions(resetOnError: false)` keeps
/// undecryptable data instead of wiping it on error. You can override both
/// options through the constructor, and the service forwards them on every
/// call.
///
/// `flutter_secure_storage` 11.x cannot read data written by 9.x on Android
/// through EncryptedSharedPreferences; the Android store resets once. This
/// package accepts that one-time reset. The iOS `first_unlock` accessibility
/// class stays unchanged, so existing items remain readable.
class SecureStorageService implements KeyValueStore {
  /// Creates a service around [storage].
  ///
  /// When you omit [storage], the service creates a default
  /// [FlutterSecureStorage] instance. [iOptions] and [aOptions] default to
  /// `first_unlock` on iOS and `resetOnError: false` on Android; the service
  /// passes both on every platform call.
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

  /// Returns the underlying [FlutterSecureStorage] instance for platform
  /// calls.
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
