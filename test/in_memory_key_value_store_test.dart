import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemoryKeyValueStore', () {
    test('implements KeyValueStore', () {
      expect(InMemoryKeyValueStore(), isA<KeyValueStore>());
    });

    test('returns null for a missing key', () async {
      final store = InMemoryKeyValueStore();

      expect(await store.read('missing'), isNull);
    });

    test('round-trips written values', () async {
      final store = InMemoryKeyValueStore();

      await store.write('token', 'abc123');

      expect(await store.read('token'), 'abc123');
    });

    test('overwrites existing values', () async {
      final store = InMemoryKeyValueStore();

      await store.write('token', 'first');
      await store.write('token', 'second');

      expect(await store.read('token'), 'second');
    });

    test('delete removes only the requested key', () async {
      final store = InMemoryKeyValueStore();

      await store.write('a', '1');
      await store.write('b', '2');
      await store.delete('a');

      expect(await store.read('a'), isNull);
      expect(await store.read('b'), '2');
    });

    test('deleteAll removes every key', () async {
      final store = InMemoryKeyValueStore();

      await store.write('a', '1');
      await store.write('b', '2');
      await store.deleteAll();

      expect(await store.read('a'), isNull);
      expect(await store.read('b'), isNull);
    });
  });
}
