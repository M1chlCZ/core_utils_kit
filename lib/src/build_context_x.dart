import 'package:flutter/widgets.dart';

/// Convenience helpers on [BuildContext].
extension BuildContextX on BuildContext {
  /// Schedules [callback] on a zero-delay timer.
  ///
  /// The timer does not follow the frame pipeline, so the callback can run
  /// after the widget is disposed. Check [State.mounted] before you touch
  /// state. Use the helper for work that must not run during `build`, such as
  /// showing a dialog or moving focus.
  void afterBuild(VoidCallback callback) {
    Future<void>.delayed(Duration.zero, callback);
  }
}
