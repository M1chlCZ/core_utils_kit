## [0.3.0] - 2026-11-18

- Require Flutter 3.47 and Dart 3.13.
- Use the `material_ui` package for Material widgets.

## [0.2.0] - 2026-10-22

- Add `formatRelativeTime`. It truncates the difference to a whole unit and
  reads `5 minutes ago`, `just now`, or `in 2 hours`.
- Add `formatLongDate`, `formatShortDate`, and `formatShortDateTime`. English
  and Czech use built-in patterns and need no locale data initialization.
  Other locales delegate to `intl`.
- Add `formatDurationHuman` for compact durations such as `1 h 05 min`,
  `45 min`, and `12 s`.
- Add `Debouncer`, `Throttler`, and the `debounced` and `throttled`
  extensions for repeated callbacks.
- Add `retry` and `RetryPolicy` with attempts, growing waits, jitter, and a
  `retryOn` filter; `delayFor` keeps tests instant.
- Add `formatBytes`, `formatCompactNumber`, and `formatPercent`.
- Add `isValidEmail`, `isValidUrl`, `isValidIban` (MOD-97), and
  `isValidE164Phone`.
- Add `initialsOf`, `slugify`, and `truncateAtWord`.

## 0.1.2

- Documentation and internal cleanup.

## 0.1.1

- Rewrite the README. The install section now uses
  `flutter pub add core_utils_kit`.

## 0.1.0

- Initial release.
- Extracted shared utilities from the Rocketbot app: `KeyValueStore`,
  `InMemoryKeyValueStore`, `SecureStorageService`, `DateFormats`,
  `DurationFormatting`, `LifecycleWatcher`, `generateMaterialColor`,
  `openLink`, `generateRandomString`, and `BuildContextX.afterBuild`.
- `DateFormats.convertDate` now converts with `toLocal`, handling
  daylight-saving transitions and explicit or fractional UTC offsets
  correctly.
- `LifecycleWatcher` fixes the inactive/paused mapping: `inactive` now calls
  `onAppInactive` and `paused` calls `onAppPaused`. Applying
  `WidgetsBindingObserver` before the mixin is enforced by the compiler.
- `generateRandomString` rejects negative lengths with an `ArgumentError`.
- `SecureStorageService` accepts injectable `AppleOptions` and `AndroidOptions`
  and defaults to `AndroidOptions(resetOnError: false)` so undecryptable
  Android data is preserved.
- Storage migration: `flutter_secure_storage` 11 cannot read version 9
  `EncryptedSharedPreferences` data on Android, so existing installs reset
  their stored tokens, PIN and preferences once. iOS `first_unlock` data
  remains readable.
- The one-time Android reset is guarded by a `storage_reset_done` marker so it
  runs at most once; later launches with unreadable storage proceed logged out
  instead of wiping again.
