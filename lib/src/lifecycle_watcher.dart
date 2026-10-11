import 'package:flutter/widgets.dart';

/// Mixes app lifecycle callbacks into a [State].
///
/// Apply [WidgetsBindingObserver] before this mixin. The `on` clause below
/// requires the host class to implement [WidgetsBindingObserver]. The compiler
/// enforces that order: the reversed order fails with
/// `mixin_application_not_implemented_interface`. It does not silently replace
/// [didChangeAppLifecycleState] with the observer's no-op default:
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget>
///     with WidgetsBindingObserver, LifecycleWatcher<MyWidget> {
///   @override
///   void onAppResumed() {
///     // The app is visible and interactive again.
///   }
/// }
/// ```
///
/// This mixin fixes the swapped mapping of the original app implementation:
/// `inactive` maps to [onAppInactive] and `paused` maps to [onAppPaused].
mixin LifecycleWatcher<T extends StatefulWidget>
    on State<T>, WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
      case AppLifecycleState.inactive:
        onAppInactive();
      case AppLifecycleState.paused:
        onAppPaused();
      case AppLifecycleState.detached:
        onAppDetached();
      case AppLifecycleState.hidden:
        onAppHidden();
    }
  }

  /// The mixin calls this hook when the app is visible and interactive again.
  void onAppResumed() {}

  /// The mixin calls this hook when the app is visible but no longer has input
  /// focus.
  void onAppInactive() {}

  /// The mixin calls this hook when the app is no longer visible.
  void onAppPaused() {}

  /// The mixin calls this hook when the app detaches from its host view.
  void onAppDetached() {}

  /// The mixin calls this hook when the app is hidden but not yet paused.
  ///
  /// The original app implementation ignored this state; this mixin exposes it
  /// as an empty hook so callers can react to it.
  void onAppHidden() {}
}
