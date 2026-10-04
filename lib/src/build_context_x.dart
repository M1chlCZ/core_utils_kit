import 'package:flutter/widgets.dart';

/// Convenience helpers on [BuildContext].
extension BuildContextX on BuildContext {
  /// Runs [callback] after the current frame completes.
  ///
  /// Useful for work that must not run during `build`, such as showing a
  /// dialog or moving focus.
  void afterBuild(VoidCallback callback) {
    Future<void>.delayed(Duration.zero, callback);
  }
}
