import 'dart:math';

import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('runs only the last call', () async {
      final calls = <int>[];
      final debouncer = Debouncer(duration: const Duration(milliseconds: 20));
      for (var index = 0; index < 5; index++) {
        debouncer(() => calls.add(index));
      }
      expect(debouncer.isPending, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(calls, <int>[4]);
      expect(debouncer.isPending, isFalse);
    });

    test('cancel drops the pending call', () async {
      var calls = 0;
      final debouncer = Debouncer(duration: const Duration(milliseconds: 20));
      debouncer(() => calls++);
      debouncer.cancel();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(calls, 0);
      expect(debouncer.isPending, isFalse);
    });

    test('the debounced extension wraps a callback', () async {
      final calls = <String>[];
      final debouncer = Debouncer(duration: const Duration(milliseconds: 20));
      void log() => calls.add('call');
      final void Function() wrapped = log.debounced(debouncer);
      wrapped();
      wrapped();
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(calls, <String>['call']);
    });
  });

  group('Throttler', () {
    test('runs once per duration and drops the calls in between', () {
      var elapsed = Duration.zero;
      final throttler = Throttler(
        duration: const Duration(milliseconds: 500),
        elapsed: () => elapsed,
      );
      final calls = <int>[];
      throttler(() => calls.add(1));
      throttler(() => calls.add(2));
      elapsed += const Duration(milliseconds: 600);
      throttler(() => calls.add(3));
      throttler(() => calls.add(4));
      expect(calls, <int>[1, 3]);
    });

    test('reset makes the next call run immediately', () {
      var elapsed = Duration.zero;
      final throttler = Throttler(
        duration: const Duration(milliseconds: 500),
        elapsed: () => elapsed,
      );
      var calls = 0;
      throttler(() => calls++);
      throttler(() => calls++);
      expect(calls, 1);
      throttler.reset();
      throttler(() => calls++);
      expect(calls, 2);
    });

    test('the throttled extension wraps a callback', () {
      var elapsed = Duration.zero;
      final throttler = Throttler(
        duration: const Duration(seconds: 1),
        elapsed: () => elapsed,
      );
      var calls = 0;
      void run() => calls++;
      final void Function() wrapped = run.throttled(throttler);
      wrapped();
      wrapped();
      expect(calls, 1);
      elapsed += const Duration(seconds: 2);
      wrapped();
      expect(calls, 2);
    });
  });

  group('retry', () {
    test('returns the first successful result and grows the wait', () async {
      var attempts = 0;
      final waits = <Duration>[];
      final String result = await retry(
        () async {
          attempts++;
          if (attempts < 3) {
            throw StateError('fail');
          }
          return 'ok';
        },
        policy: const RetryPolicy(jitter: 0),
        delayFor: (wait) async {
          waits.add(wait);
        },
      );
      expect(result, 'ok');
      expect(attempts, 3);
      expect(waits, <Duration>[
        const Duration(milliseconds: 200),
        const Duration(milliseconds: 400),
      ]);
    });

    test('rethrows the last error after the final attempt', () async {
      var attempts = 0;
      await expectLater(
        retry(
          () async {
            attempts++;
            throw StateError('fail $attempts');
          },
          policy: const RetryPolicy(jitter: 0),
          delayFor: (_) async {},
        ),
        throwsA(
          isA<StateError>().having(
            (StateError error) => error.message,
            'message',
            'fail 3',
          ),
        ),
      );
      expect(attempts, 3);
    });

    test('stops when retryOn returns false', () async {
      var attempts = 0;
      await expectLater(
        retry(
          () async {
            attempts++;
            throw ArgumentError('permanent');
          },
          policy: RetryPolicy(retryOn: (Object error) => error is StateError),
          delayFor: (_) async {},
        ),
        throwsA(isA<ArgumentError>()),
      );
      expect(attempts, 1);
    });

    test('tries once when attempts is one', () async {
      var attempts = 0;
      await expectLater(
        retry(
          () async {
            attempts++;
            throw StateError('fail');
          },
          policy: const RetryPolicy(attempts: 1),
          delayFor: (_) async {},
        ),
        throwsA(isA<StateError>()),
      );
      expect(attempts, 1);
    });

    test('keeps the jitter inside its bounds', () async {
      final waits = <Duration>[];
      var attempts = 0;
      await retry(
        () async {
          attempts++;
          if (attempts < 8) {
            throw StateError('fail');
          }
          return attempts;
        },
        policy: const RetryPolicy(attempts: 8, jitter: 0.5),
        random: Random(1),
        delayFor: (wait) async {
          waits.add(wait);
        },
      );
      Duration expected = const Duration(milliseconds: 200);
      for (final Duration wait in waits) {
        expect(
          wait.inMicroseconds,
          greaterThanOrEqualTo(expected.inMicroseconds ~/ 2),
        );
        expect(
          wait.inMicroseconds,
          lessThanOrEqualTo(
            expected.inMicroseconds + expected.inMicroseconds ~/ 2,
          ),
        );
        expected = expected * 2;
      }
    });
  });
}
