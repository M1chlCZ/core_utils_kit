/// A minimal asynchronous key-value store abstraction.
///
/// Implementations may be backed by secure platform storage, an in-memory
/// map, or any other persistence layer.
abstract interface class KeyValueStore {
  /// Reads the value stored for [key].
  ///
  /// Returns `null` when no value is stored for [key].
  Future<String?> read(String key);

  /// Stores [value] under [key], replacing any previous value.
  Future<void> write(String key, String value);

  /// Removes the value stored for [key].
  ///
  /// Does nothing when [key] is absent.
  Future<void> delete(String key);

  /// Removes every value from the store.
  Future<void> deleteAll();
}

/// A [KeyValueStore] backed by an in-memory [Map].
///
/// Values do not survive process restarts. Useful for tests and for
/// non-persistent caches.
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
