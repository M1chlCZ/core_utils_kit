import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreUtilsExampleApp());
}

class CoreUtilsExampleApp extends StatelessWidget {
  const CoreUtilsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'core_utils_kit example',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF9BD41E),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with WidgetsBindingObserver, LifecycleWatcher<ExampleHomePage> {
  final KeyValueStore _store = InMemoryKeyValueStore();

  String _storeResult = 'Running...';
  String _lifecycleStatus = 'Waiting for a lifecycle event';

  @override
  void initState() {
    super.initState();
    _runStoreDemo();
  }

  Future<void> _runStoreDemo() async {
    await _store.write('answer', '42');
    final String? value = await _store.read('answer');
    await _store.delete('answer');
    final String? afterDelete = await _store.read('answer');
    setState(() {
      _storeResult = 'read: $value, after delete: $afterDelete';
    });
  }

  @override
  void onAppResumed() {
    setState(() {
      _lifecycleStatus = 'resumed';
    });
  }

  @override
  void onAppInactive() {
    setState(() {
      _lifecycleStatus = 'inactive';
    });
  }

  @override
  void onAppPaused() {
    setState(() {
      _lifecycleStatus = 'paused';
    });
  }

  @override
  void onAppDetached() {
    if (mounted) {
      setState(() {
        _lifecycleStatus = 'detached';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Duration duration = Duration(
      days: 1,
      hours: 2,
      minutes: 3,
      seconds: 4,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('core_utils_kit example')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const _SectionTitle('InMemoryKeyValueStore round-trip'),
          Text(_storeResult),
          const Divider(height: 32),
          const _SectionTitle('Duration formatting'),
          Text(
            'DateFormats.formatDuration: '
            '${DateFormats.formatDuration(duration)}',
          ),
          Text(
            'toHoursMinutes: '
            '${const Duration(hours: 5, minutes: 15).toHoursMinutes()}',
          ),
          Text(
            'toHoursMinutesSeconds: '
            '${const Duration(hours: 5, minutes: 15, seconds: 35).toHoursMinutesSeconds()}',
          ),
          const Divider(height: 32),
          const _SectionTitle('Date formatting'),
          Text('utcDayStart: ${DateFormats.utcDayStart()}'),
          Text(
            'convertDate: '
            '${DateFormats.convertDate('2024-03-31T01:30:00+02:00')}',
          ),
          const Divider(height: 32),
          const _SectionTitle('LifecycleWatcher'),
          Text('Last event: $_lifecycleStatus'),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
