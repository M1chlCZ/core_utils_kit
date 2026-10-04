import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class _LifecycleProbe extends StatefulWidget {
  const _LifecycleProbe();

  @override
  State<_LifecycleProbe> createState() => _LifecycleProbeState();
}

// `WidgetsBindingObserver` must precede `LifecycleWatcher`: the mixin's `on`
// clause requires the host to implement the observer interface, so the
// reversed order is rejected at compile time with
// `mixin_application_not_implemented_interface`.
class _LifecycleProbeState extends State<_LifecycleProbe>
    with WidgetsBindingObserver, LifecycleWatcher<_LifecycleProbe> {
  final List<String> hooks = <String>[];

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  void onAppResumed() => hooks.add('resumed');

  @override
  void onAppInactive() => hooks.add('inactive');

  @override
  void onAppPaused() => hooks.add('paused');

  @override
  void onAppDetached() => hooks.add('detached');

  @override
  void onAppHidden() => hooks.add('hidden');
}

class _BareLifecycleProbe extends StatefulWidget {
  const _BareLifecycleProbe();

  @override
  State<_BareLifecycleProbe> createState() => _BareLifecycleProbeState();
}

class _BareLifecycleProbeState extends State<_BareLifecycleProbe>
    with WidgetsBindingObserver, LifecycleWatcher<_BareLifecycleProbe> {
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  testWidgets('maps each lifecycle state to the correct hook', (tester) async {
    await tester.pumpWidget(const _LifecycleProbe());
    final state = tester.state<_LifecycleProbeState>(
      find.byType(_LifecycleProbe),
    );

    state.didChangeAppLifecycleState(AppLifecycleState.resumed);
    expect(state.hooks, ['resumed']);

    state.didChangeAppLifecycleState(AppLifecycleState.inactive);
    expect(state.hooks, ['resumed', 'inactive']);

    state.didChangeAppLifecycleState(AppLifecycleState.paused);
    expect(state.hooks, ['resumed', 'inactive', 'paused']);

    state.didChangeAppLifecycleState(AppLifecycleState.detached);
    expect(state.hooks, ['resumed', 'inactive', 'paused', 'detached']);

    state.didChangeAppLifecycleState(AppLifecycleState.hidden);
    expect(state.hooks, [
      'resumed',
      'inactive',
      'paused',
      'detached',
      'hidden',
    ]);
  });

  testWidgets('registers itself as a binding observer while mounted', (
    tester,
  ) async {
    await tester.pumpWidget(const _LifecycleProbe());
    final state = tester.state<_LifecycleProbeState>(
      find.byType(_LifecycleProbe),
    );

    // ignore: invalid_use_of_protected_member
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    expect(state.hooks, ['paused']);
  });

  testWidgets('removes the observer on dispose', (tester) async {
    await tester.pumpWidget(const _LifecycleProbe());
    final state = tester.state<_LifecycleProbeState>(
      find.byType(_LifecycleProbe),
    );

    await tester.pumpWidget(const SizedBox.shrink());

    // ignore: invalid_use_of_protected_member
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

    expect(state.hooks, isEmpty);
  });

  testWidgets('hooks are empty by default', (tester) async {
    await tester.pumpWidget(const _BareLifecycleProbe());
    final state = tester.state<_BareLifecycleProbeState>(
      find.byType(_BareLifecycleProbe),
    );

    for (final lifecycleState in AppLifecycleState.values) {
      state.didChangeAppLifecycleState(lifecycleState);
    }
  });
}
