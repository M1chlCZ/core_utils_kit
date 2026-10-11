/// A minimal asynchronous key-value store abstraction.
///
/// Implementations can use secure platform storage, an in-memory map, or any
/// other persistence layer.
abstract interface class KeyValueStore {
  /// Reads the value for [key].
  ///
  /// Returns `null` when the store holds no value for [key].
  Future<String?> read(String key);

  /// Stores [value] under [key], replacing any previous value.
  Future<void> write(String key, String value);

  /// Removes the value for [key].
  ///
  /// Does nothing when [key] is absent.
  Future<void> delete(String key);

  /// Removes every value from the store.
  Future<void> deleteAll();
}

/// A [KeyValueStore] that stores values in an in-memory [Map].
///
/// Values do not survive process restarts. Use it in tests and non-persistent
/// caches.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }
}
