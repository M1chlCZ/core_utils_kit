/// Runs at most one call per [duration] and drops the calls in between.
///
/// Use a throttler for scroll listeners, drag updates, and network refreshes:
///
/// ```dart
/// final throttler = Throttler(duration: Duration(milliseconds: 500));
/// onScroll: () => throttler(refresh),
/// ```
class Throttler {
  /// Creates a throttler with the minimum time between two runs.
  ///
  /// [clock] replaces the current time source, which keeps tests instant.
  Throttler({
    this.duration = const Duration(milliseconds: 500),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  /// Minimum time between two runs of the callback.
  final Duration duration;

  final DateTime Function() _clock;
  DateTime? _lastRun;

  /// Runs [callback] when enough time passed since the last run.
  void call(void Function() callback) {
    final DateTime now = _clock();
    final DateTime? last = _lastRun;
    if (last != null && now.difference(last) < duration) {
      return;
    }
    _lastRun = now;
    callback();
  }

  /// Forgets the last run, so the next call runs immediately.
  void reset() {
    _lastRun = null;
  }
}
