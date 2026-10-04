# core_utils_kit

Small Flutter utilities: secure key-value storage, date and time formatting,
color generation, URL opening, random strings, and app lifecycle watching
without extra state-management dependencies.

## Features

| API | Description |
| --- | --- |
| `KeyValueStore` | Asynchronous key-value store interface with `read`, `write`, `delete`, and `deleteAll`. |
| `InMemoryKeyValueStore` | `KeyValueStore` backed by a `Map`, useful for tests. |
| `SecureStorageService` | `KeyValueStore` backed by `flutter_secure_storage` with injectable options. |
| `DateFormats.utcDayStart` | Current local day start expressed in UTC as `yyyy-MM-dd HH:mm:ss`. |
| `DateFormats.convertDate` | ISO-8601 string to a localized date and time string. |
| `DateFormats.formatDuration` | `Duration` to a compact `d:h:m:s` string. |
| `DurationFormatting` | `Duration` extension with `toHoursMinutes` and `toHoursMinutesSeconds`. |
| `LifecycleWatcher` | Mixin that forwards app lifecycle events to `onApp*` hooks. |
| `generateMaterialColor` | Builds a `MaterialColor` swatch from a base color. |
| `tintColor`, `shadeColor` | Lighten or darken a color by a factor. |
| `openLink` | Opens a `Uri` with fallback launch modes. |
| `generateRandomString` | Random alphanumeric string of a given length. |
| `BuildContextX.afterBuild` | Schedules a callback for after the current build. |

## Install

`core_utils_kit` is not published on pub.dev yet. Depend on it with a path:

```yaml
dependencies:
  core_utils_kit:
    path: packages/core_utils_kit
```

## Usage

### Secure storage

Create one shared store and reuse it across the app:

```dart
import 'package:core_utils_kit/core_utils_kit.dart';

final KeyValueStore secureStore = SecureStorageService();

Future<void> saveToken() async {
  await secureStore.write('token', 'abc123');
  final String? token = await secureStore.read('token');
  await secureStore.delete('token');
  await secureStore.deleteAll();
}
```

Use `InMemoryKeyValueStore` when persistence is not needed, for example in
tests:

```dart
final KeyValueStore store = InMemoryKeyValueStore();
await store.write('answer', '42');
expect(await store.read('answer'), '42');
```

`SecureStorageService` accepts custom `iOptions` and `aOptions`. The defaults
are `KeychainAccessibility.first_unlock` on Apple platforms and
`AndroidOptions(resetOnError: false)` on Android, so undecryptable Android
entries are preserved instead of being wiped on error:

```dart
final KeyValueStore store = SecureStorageService(
  aOptions: const AndroidOptions(resetOnError: true),
);
```

### Dates and durations

```dart
final String dayStart = DateFormats.utcDayStart();

// Non-en locales need their symbol data first:
// await initializeDateFormatting('fi');
final String posted = DateFormats.convertDate('2024-03-31T01:30:00+02:00', 'fi');

final String compact = DateFormats.formatDuration(
  const Duration(days: 1, hours: 2, minutes: 3, seconds: 4),
); // 1d:2h:3m:4s

final String clock = const Duration(hours: 5, minutes: 15).toHoursMinutes();
// 05:15
```

`convertDate` converts the parsed value with `toLocal`, so daylight-saving
transitions and explicit or fractional UTC offsets are handled correctly.

### Lifecycle watching

Apply `WidgetsBindingObserver` **before** `LifecycleWatcher`. The mixin's `on`
clause requires `WidgetsBindingObserver`, so the compiler rejects the reversed
order instead of silently discarding the observer:

```dart
class _ScreenState extends State<Screen>
    with WidgetsBindingObserver, LifecycleWatcher<Screen> {
  @override
  void onAppResumed() {
    // The app is visible and interactive again.
  }

  @override
  void onAppInactive() {
    // Visible but without input focus.
  }

  @override
  void onAppPaused() {
    // No longer visible.
  }

  @override
  void onAppDetached() {
    // Detached from its host view.
  }
}
```

`ConsumerState` based widgets keep `ConsumerStatefulWidget` / `ConsumerState`
and add both mixins after the base class:

```dart
class _HomeState extends ConsumerState<Home>
    with WidgetsBindingObserver, LifecycleWatcher<Home> {
  @override
  void onAppResumed() {}
}
```

### Opening links, colors, and random strings

```dart
final bool opened = await openLink(Uri.parse('https://rocket.art'));

final MaterialColor swatch = generateMaterialColor(const Color(0xFF9BD41E));

final String nonce = generateRandomString(16);
```

### After build

```dart
context.afterBuild(() {
  if (mounted) {
    // Show a dialog, move focus, or run other work that must not happen
    // during build.
  }
});
```

## Platforms

The package does not import `dart:io`, so it compiles for every Flutter
target. `SecureStorageService` delegates to `flutter_secure_storage`, which
supports Android, iOS and desktop (macOS, Linux, Windows) with the platform
keychain or credential store; on Linux it needs `libsecret`.

## Storage migration

`flutter_secure_storage` 11 changed the Android backend. It cannot read data
written by version 9 through `EncryptedSharedPreferences`, so existing Android
installs lose their stored tokens, PIN and preferences once after the upgrade.
This is an accepted, one-time reset. iOS items written with the `first_unlock`
accessibility class remain readable because that class is unchanged.

Android errors are not destructive by default: `AndroidOptions(resetOnError:
false)` keeps undecryptable entries instead of deleting them. If a wipe on
read error is preferred, inject `aOptions: const AndroidOptions(resetOnError:
true)`.