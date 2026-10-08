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
| `DurationFormatting` | `toHoursMinutes` and `toHoursMinutesSeconds` extensions. |
| `LifecycleWatcher` | Mixin that forwards app lifecycle events to `onApp*` hooks. |
| `generateMaterialColor`, `tintColor`, `shadeColor` | Color helpers. |
| `openLink` | Opens a `Uri` with fallback launch modes. |
| `generateRandomString` | Random alphanumeric string of a given length. |
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
