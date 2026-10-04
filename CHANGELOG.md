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
