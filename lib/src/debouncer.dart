import 'dart:async';

/// Delays repeated calls and runs only the last one.
///
/// Use a debouncer for search fields, resize handlers, and validation that
/// should run after the user stops typing:
///
/// ```dart
/// final debouncer = Debouncer(duration: Duration(milliseconds: 300));
/// onChanged: (text) => debouncer(() => search(text)),
/// ```
class Debouncer {
  /// Creates a debouncer with the delay between the last call and the run.
  Debouncer({this.duration = const Duration(milliseconds: 300)});

  /// Time between the last call and the run of the callback.
  final Duration duration;

  Timer? _timer;

  /// Calls [callback] after [duration] when no newer call arrived.
  ///
  /// Every call restarts the delay, so only the last callback runs.
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Whether a call is waiting for its run.
  bool get isPending => _timer?.isActive ?? false;

  /// Drops a pending call.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}
