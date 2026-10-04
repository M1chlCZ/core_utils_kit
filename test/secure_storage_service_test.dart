import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingSecureStorage extends FlutterSecureStorage {
  _RecordingSecureStorage();

  final List<String> calls = <String>[];
  AppleOptions? lastIOptions;
  AndroidOptions? lastAOptions;

  void _record(
    String call, {
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    calls.add(call);
    lastIOptions = iOptions;
    lastAOptions = aOptions;
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _record('read:$key', iOptions: iOptions, aOptions: aOptions);
    return 'value:$key';
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _record('write:$key=$value', iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _record('delete:$key', iOptions: iOptions, aOptions: aOptions);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _record('deleteAll', iOptions: iOptions, aOptions: aOptions);
  }
}

class _ThrowingSecureStorage extends FlutterSecureStorage {
  const _ThrowingSecureStorage();

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'read_failed');

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'write_failed');

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'delete_failed');

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'delete_all_failed');
}

void main() {
  group('SecureStorageService', () {
    test('implements KeyValueStore', () {
      expect(SecureStorageService(), isA<KeyValueStore>());
    });

    test(
      'forwards calls to the injected storage with secure options',
      () async {
        final storage = _RecordingSecureStorage();
        final service = SecureStorageService(storage: storage);

        expect(await service.read('token'), 'value:token');
        await service.write('token', 'abc');
        await service.delete('token');
        await service.deleteAll();

        expect(storage.calls, [
          'read:token',
          'write:token=abc',
          'delete:token',
          'deleteAll',
        ]);
        expect(
          storage.lastIOptions?.accessibility,
          KeychainAccessibility.first_unlock,
        );
        expect(storage.lastAOptions, isA<AndroidOptions>());
      },
    );

    test('round-trips values through the default storage', () async {
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
      final service = SecureStorageService();

      await service.write('key', 'value');
      expect(await service.read('key'), 'value');

      await service.delete('key');
      expect(await service.read('key'), isNull);

      await service.write('a', '1');
      await service.write('b', '2');
      await service.deleteAll();
      expect(await service.read('a'), isNull);
      expect(await service.read('b'), isNull);
    });

    group('swallows platform errors', () {
      test('read returns null', () async {
        final service = SecureStorageService(
          storage: const _ThrowingSecureStorage(),
        );

        expect(await service.read('key'), isNull);
      });

      test('write, delete, and deleteAll complete normally', () async {
        final service = SecureStorageService(
          storage: const _ThrowingSecureStorage(),
        );

        await expectLater(service.write('key', 'value'), completes);
        await expectLater(service.delete('key'), completes);
        await expectLater(service.deleteAll(), completes);
      });
    });
  });
}
