import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _Call = ({
  String name,
  AppleOptions? iOptions,
  AndroidOptions? aOptions,
});

class _RecordingSecureStorage extends FlutterSecureStorage {
  _RecordingSecureStorage();

  final List<_Call> calls = <_Call>[];

  void _record(
    String call, {
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
  }) {
    calls.add((name: call, iOptions: iOptions, aOptions: aOptions));
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

class _NullReadSecureStorage extends FlutterSecureStorage {
  const _NullReadSecureStorage();

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => null;
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

    test('exposes the underlying FlutterSecureStorage', () {
      final storage = _RecordingSecureStorage();

      expect(SecureStorageService(storage: storage).storage, same(storage));
    });

    test('forwards calls to the injected storage', () async {
      final storage = _RecordingSecureStorage();
      final service = SecureStorageService(storage: storage);

      expect(await service.read('token'), 'value:token');
      await service.write('token', 'abc');
      await service.delete('token');
      await service.deleteAll();

      expect(storage.calls.map((call) => call.name), [
        'read:token',
        'write:token=abc',
        'delete:token',
        'deleteAll',
      ]);
    });

    test(
      'defaults to first_unlock on iOS and resetOnError false on Android',
      () async {
        final storage = _RecordingSecureStorage();
        final service = SecureStorageService(storage: storage);

        await service.read('token');

        final call = storage.calls.single;
        expect(call.iOptions, isA<IOSOptions>());
        expect(
          call.iOptions?.accessibility,
          KeychainAccessibility.first_unlock,
        );
        expect(call.aOptions, isA<AndroidOptions>());
        expect(call.aOptions?.toMap()['resetOnError'], 'false');
      },
    );

    test('passes the injected options to every storage call', () async {
      const ios = IOSOptions(accessibility: KeychainAccessibility.unlocked);
      const android = AndroidOptions(
        resetOnError: true,
        preferencesKeyPrefix: 'rb',
      );
      final storage = _RecordingSecureStorage();
      final service = SecureStorageService(
        storage: storage,
        iOptions: ios,
        aOptions: android,
      );

      await service.read('a');
      await service.write('b', 'value');
      await service.delete('c');
      await service.deleteAll();

      expect(storage.calls, hasLength(4));
      for (final call in storage.calls) {
        expect(identical(call.iOptions, ios), isTrue);
        expect(identical(call.aOptions, android), isTrue);
      }
    });

    test('read returns null when the storage holds no value', () async {
      final service = SecureStorageService(
        storage: const _NullReadSecureStorage(),
      );

      expect(await service.read('missing'), isNull);
    });

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
