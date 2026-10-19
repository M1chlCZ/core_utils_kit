import 'dart:async';
import 'dart:math';

/// Retry settings for [retry].
class RetryPolicy {
  /// Creates a retry policy.
  ///
  /// [attempts] is the total number of tries, including the first one.
  /// [delay] is the wait before the second try; every further wait grows by
  /// [factor]. [jitter] adds up to this fraction of the wait in both
  /// directions, which spreads retries of several clients.
  const RetryPolicy({
    this.attempts = 3,
    this.delay = const Duration(milliseconds: 200),
    this.factor = 2,
    this.jitter = 0.2,
    this.retryOn,
  }) : assert(attempts > 0, 'attempts must be positive'),
       assert(factor >= 1, 'factor must be at least 1'),
       assert(jitter >= 0 && jitter <= 1, 'jitter must be in [0, 1]');

  /// Total number of tries, including the first one.
  final int attempts;

  /// Wait before the second try.
  final Duration delay;

  /// Multiplier applied to the wait after every failed try.
  final double factor;

  /// Random fraction added to or removed from each wait, between 0 and 1.
  final double jitter;

  /// Called with the error of a failed try; return false to stop retrying.
  final bool Function(Object error)? retryOn;
}

/// Runs [action] again when it throws, following [policy].
///
/// The function waits between tries and grows the wait by
/// [RetryPolicy.factor]. [delayFor] replaces the wait, which keeps tests
/// instant. [random] seeds the jitter. The last error is rethrown when every
/// try fails or when [RetryPolicy.retryOn] returns false.
Future<T> retry<T>(
  Future<T> Function() action, {
  RetryPolicy policy = const RetryPolicy(),
  Future<void> Function(Duration duration)? delayFor,
  Random? random,
}) async {
  final Random source = random ?? Random();
  for (var attempt = 1; ; attempt++) {
    try {
      return await action();
    } catch (error) {
      final bool retryable = policy.retryOn?.call(error) ?? true;
      if (!retryable || attempt >= policy.attempts) {
        rethrow;
      }
      final Duration wait = _waitFor(attempt, policy, source);
      if (delayFor != null) {
        await delayFor(wait);
      } else if (wait > Duration.zero) {
        await Future<void>.delayed(wait);
      }
    }
  }
}

Duration _waitFor(int attempt, RetryPolicy policy, Random random) {
  final double base =
      (policy.delay.inMicroseconds * pow(policy.factor, attempt - 1))
          .toDouble();
  final double spread = 1 + (random.nextDouble() * 2 - 1) * policy.jitter;
  return Duration(microseconds: (base * spread).round());
}
