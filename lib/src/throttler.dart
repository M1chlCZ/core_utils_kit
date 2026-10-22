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
  /// The default elapsed source is a monotonic stopwatch, so wall-clock
  /// changes do not stall or repeat calls. [elapsed] replaces the source,
  /// which keeps tests instant.
  Throttler({
    this.duration = const Duration(milliseconds: 500),
    Duration Function()? elapsed,
  }) {
    final stopwatch = Stopwatch()..start();
    _elapsed = elapsed ?? () => stopwatch.elapsed;
  }

  /// Minimum time between two runs of the callback.
  final Duration duration;

  late final Duration Function() _elapsed;
  Duration? _lastRun;

  /// Runs [callback] when enough time passed since the last run.
  void call(void Function() callback) {
    final Duration now = _elapsed();
    final Duration? last = _lastRun;
    if (last != null && now - last < duration) {
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
