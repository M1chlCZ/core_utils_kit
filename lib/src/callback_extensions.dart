import 'debouncer.dart';
import 'throttler.dart';

/// Adds debouncing and throttling to a callback.
///
/// The extension keeps the call site short:
///
/// ```dart
/// onChanged: search.debounced(debouncer),
/// onScroll: refresh.throttled(throttler),
/// ```
extension DebouncedCallback on void Function() {
  /// Returns a function that runs this callback after [debouncer]'s delay.
  ///
  /// Every call restarts the delay, so only the last call runs.
  void Function() debounced(Debouncer debouncer) =>
      () => debouncer(this);

  /// Returns a function that runs this callback at most once per
  /// [throttler]'s duration.
  void Function() throttled(Throttler throttler) =>
      () => throttler(this);
}
