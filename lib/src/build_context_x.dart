import 'package:flutter/widgets.dart';

/// Convenience helpers on [BuildContext].
extension BuildContextX on BuildContext {
  /// Schedules [callback] on a zero-delay timer.
  ///
  /// The callback is not tied to the frame pipeline, so it may run after the
  /// widget is disposed; check [State.mounted] before touching state. Useful
  /// for work that must not run during `build`, such as showing a dialog or
  /// moving focus.
  void afterBuild(VoidCallback callback) {
    Future<void>.delayed(Duration.zero, callback);
  }
}
