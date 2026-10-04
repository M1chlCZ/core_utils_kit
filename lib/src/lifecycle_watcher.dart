import 'package:flutter/widgets.dart';

/// Mixes app lifecycle callbacks into a [State].
///
/// Apply [WidgetsBindingObserver] before this mixin so the default observer
/// implementations are available:
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
mixin LifecycleWatcher<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
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

  /// Called when the app is visible and interactive again.
  void onAppResumed() {}

  /// Called when the app is visible but no longer has input focus.
  void onAppInactive() {}

  /// Called when the app is no longer visible.
  void onAppPaused() {}

  /// Called when the app is detached from its host view.
  void onAppDetached() {}

  /// Called when the app is hidden but not yet paused.
  ///
  /// The original app implementation ignored this state; it is exposed here
  /// as an empty hook so callers can react to it.
  void onAppHidden() {}
}
