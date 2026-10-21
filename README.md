# core_utils_kit

Small Flutter utilities: secure key-value storage, date and time formatting,
color generation, URL opening, random strings, and app lifecycle hooks. The
package adds no state-management dependency.

## Features

| API | Purpose |
| --- | --- |
| `KeyValueStore` | Key-value store interface with `read`, `write`, `delete`, and `deleteAll`. |
| `InMemoryKeyValueStore` | `KeyValueStore` backed by a `Map`. Use it in tests. |
| `SecureStorageService` | `KeyValueStore` backed by `flutter_secure_storage`. |
| `DateFormats` | `utcDayStart`, `convertDate`, and `formatDuration`. |
| `formatRelativeTime` | Short phrases such as `5 minutes ago` or `in 2 hours`. |
| `formatLongDate`, `formatShortDate`, `formatShortDateTime` | Locale-aware dates. English and Czech need no initialization. |
| `DurationFormatting` | `toHoursMinutes` and `toHoursMinutesSeconds` extensions. |
| `formatDurationHuman` | Compact durations such as `1 h 05 min` and `45 min`. |
| `LifecycleWatcher` | Mixin that forwards app lifecycle events to `onApp*` hooks. |
| `generateMaterialColor`, `tintColor`, `shadeColor` | Color helpers. |
| `openLink` | Opens a `Uri` with fallback launch modes. |
| `generateRandomString` | Random alphanumeric string of a given length. |
| `Debouncer`, `Throttler` | Drop repeated calls; the `debounced` and `throttled` extensions wrap callbacks. |
| `retry`, `RetryPolicy` | Retries a failing future with growing waits and jitter. |
| `formatBytes` | Binary byte sizes such as `1.5 KiB` and `2.0 MiB`. |
| `formatCompactNumber`, `formatPercent` | Compact counts such as `1.2k` and percentages such as `25.6 %`. |
| `isValidEmail`, `isValidUrl`, `isValidIban`, `isValidE164Phone` | Form validators. |
| `initialsOf`, `slugify`, `truncateAtWord` | Small text helpers. |
| `BuildContextX.afterBuild` | Runs a callback after the current build. |

## Install

```bash
flutter pub add core_utils_kit
```

## Usage

### Secure storage

```dart
final KeyValueStore store = SecureStorageService();
await store.write('token', 'abc123');
final String? token = await store.read('token');
```

`SecureStorageService` accepts `iOptions` and `aOptions`. The defaults are
`KeychainAccessibility.first_unlock` on iOS and
`AndroidOptions(resetOnError: false)` on Android.

### Dates and durations

```dart
final String dayStart = DateFormats.utcDayStart();
final String posted = DateFormats.convertDate('2024-03-31T01:30:00+02:00', 'fi');
final String compact = DateFormats.formatDuration(
  const Duration(days: 1, hours: 2, minutes: 3, seconds: 4),
); // 1d:2h:3m:4s
final String clock = const Duration(hours: 5, minutes: 15).toHoursMinutes(); // 05:15
```

Call `initializeDateFormatting('fi')` before you use a non-English locale.
When you omit the locale, `convertDate` uses `Intl.getCurrentLocale()`.

`formatDurationHuman` truncates seconds and pads minutes after hours:

```dart
formatDurationHuman(const Duration(hours: 1, minutes: 5)); // 1 h 05 min
formatDurationHuman(const Duration(minutes: 45)); // 45 min
formatDurationHuman(const Duration(seconds: 90)); // 1 min
formatDurationHuman(const Duration(seconds: 12)); // 12 s
```

### Relative time

`formatRelativeTime` truncates the difference to a whole unit. A future time
reads `in X unit`:

```dart
final now = DateTime(2024, 3, 15, 12);
formatRelativeTime(DateTime(2024, 3, 15, 11, 45), now: now); // 15 minutes ago
formatRelativeTime(DateTime(2024, 3, 15, 12, 0, 30), now: now); // just now
formatRelativeTime(DateTime(2024, 3, 15, 12, 30), now: now); // in 30 minutes
```

### Locale-aware dates

English and Czech work without locale data. Another locale delegates to
`intl`, so call `initializeDateFormatting(locale)` first:

```dart
final date = DateTime(2024, 3, 15, 14, 30);
formatLongDate(date); // March 15, 2024
formatLongDate(date, locale: 'cs'); // 15. března 2024
formatShortDate(date); // 3/15/2024
formatShortDate(date, locale: 'cs'); // 15. 3. 2024
formatShortDateTime(date, locale: 'cs'); // 15. 3. 2024 14:30
```

### Lifecycle

Apply `WidgetsBindingObserver` before `LifecycleWatcher`:

```dart
class _ScreenState extends State<Screen>
    with WidgetsBindingObserver, LifecycleWatcher<Screen> {
  @override
  void onAppResumed() {}

  @override
  void onAppInactive() {}

  @override
  void onAppPaused() {}

  @override
  void onAppDetached() {}
}
```

### Links, colors, and random strings

```dart
final bool opened = await openLink(Uri.parse('https://rocket.art'));
final MaterialColor swatch = generateMaterialColor(const Color(0xFF9BD41E));
final String nonce = generateRandomString(16);
```

### Async helpers

`Debouncer` drops calls that arrive before the delay ends, and `Throttler`
runs at most one call per duration:

```dart
final debouncer = Debouncer(duration: Duration(milliseconds: 300));
final throttler = Throttler(duration: Duration(milliseconds: 500));

onChanged: (text) => search(text).debounced(debouncer),
onScroll: () => refresh().throttled(throttler),
```

`retry` runs a failing future again with growing waits and jitter. The
`delayFor` argument replaces the wait, which keeps tests instant:

```dart
final result = await retry(
  () => client.fetchPage(1),
  policy: RetryPolicy(attempts: 4, delay: Duration(milliseconds: 200)),
);
```

### Formatting

```dart
formatBytes(1536); // 1.5 KiB
formatCompactNumber(3400000); // 3.4M
formatPercent(0.256); // 25.6 %
```

### Validators

The validators are shape checks for forms. They do not prove that an address
or account exists:

```dart
isValidEmail('ada@example.com'); // true
isValidUrl('https://example.com'); // true
isValidIban('CZ65 0800 0000 1920 0014 5399'); // true
isValidE164Phone('+420601123456'); // true
```

### Text helpers

```dart
initialsOf('Ada Lovelace'); // AL
slugify('Příliš žluťoučký kůň'); // prilis-zlutoucky-kun
truncateAtWord('The quick brown fox', 12); // The quick…
```

### After build

```dart
context.afterBuild(() {
  // Run work that must not happen during build.
});
```

## Platforms

The package compiles for every Flutter target. `SecureStorageService` uses
`flutter_secure_storage`, which supports Android, iOS, macOS, Linux, and
Windows. On Linux it needs `libsecret`.

## Storage migration

`flutter_secure_storage` 11 cannot read Android data that version 9 wrote. An
app that upgrades loses its stored tokens and preferences one time. iOS items
with the `first_unlock` accessibility class remain readable.

## Example

The [`example/`](example/) app shows the store, the date helpers, and the
lifecycle hooks.
