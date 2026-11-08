# Changelog

All notable changes to the Stringboot iOS SDK. Versions follow [Semantic Versioning](https://semver.org).

## 3.0.0 (2026-11)

**Breaking: required upgrade.** The Stringboot API now serves Devices through the edge-cached Device API v3 (`/v3/c/...`). The endpoints SDK 1.x/2.x used (`/api/v1/client/**`, `/api/v1/client/strings-v2/**`, FAQ, language, meta and delta-sync endpoints) answer **`426 Upgrade Required`**, so app builds with an older SDK keep showing their cached strings but **receive no more updates** until they ship 3.0.

### Distribution and requirements (release testing)

- Shipped as a **binary Swift package**: `https://github.com/Stringboot-SDK/stringboot-ios-sdk` (`StringbootSDK.xcframework`, built with library evolution, so newer Xcode versions can use it). Xcode embeds it automatically.
- Minimum platforms: **iOS 15 / macOS 12**.
- Includes a privacy manifest (`PrivacyInfo.xcprivacy`): UserDefaults (reason CA92.1), and the Device ID declared as collected, not linked to the user, not used for tracking, for app functionality.

### Fixed during release testing

- Upgrading from 2.x keeps the cached strings and FAQs. The 2.x store was opened read-only, which fails for a store left in WAL state by a killed app, so the cache was discarded.
- `FAQProvider` no longer caches a partial tag at start-up, so `getFAQs` always returns the full list (Catalogs with more than 100 FAQs lost the last FAQs of a tag).
- `startPeriodicSync(interval:)` defaults to 60 s (was 300 s), as on Android.

### Added

- A key missing from the selected language's Catalog now falls back to the stored Catalog of the App's default language, before the app bundle and `??key??` (the same chain as Android). While another language is selected, the SDK keeps the default language's Catalog: one background download, then at most one `/current` check a day. Periodic checks still cover only the selected language.
- After a sync fails because the Device is offline, the SDK syncs again as soon as the network returns (NWPathMonitor). A server's `429`/`503` `Retry-After` is still honoured.

### Fixed

- **Certificate pinning** (`enableCertificatePinning`): the pins were invalid (a stale leaf key and the SHA-256 of empty input). They are now the Google Trust Services WE1 intermediate and GTS Root R4, with GTS Root R1, ISRG Root X1 and ISRG Root X2 as backups. Pins are computed from the certificate's own SubjectPublicKeyInfo, so EC P-384 and RSA-4096 keys match; before, only RSA-2048 and EC P-256 hashed correctly, so a pin on GTS Root R4 or an RSA-4096 root could never match. Pinning applies only to `api.stringboot.com`.
- `startPeriodicSync(interval: 60)` skipped every other tick, so edits could take about two minutes to arrive. Checks now run every 60 s.
- A lower Catalog Version from a lagging edge (or an older Catalog body) no longer replaces the stored Catalog.
- Stored Catalogs belong to one Client Token and base URL. Configuring another App or environment discards the previous App's Catalogs instead of serving them; the Device-ID is kept.
- A `404` on `/current` now always refreshes `/languages`.
- `onExperimentsAssigned` is called when a language starts or stops falling back to the default language, even when the default's Catalog is unchanged (`304`).
- A cold start without network no longer requests `/languages` twice.
- Swift concurrency warnings in `SBLabel` and `SBButton`.

### How sync works now

1. `GET /v3/c/{clientToken}/languages`: active languages and the default language.
2. `GET /v3/c/{clientToken}/{lang}/current` with `If-None-Match: "N"`: the current Catalog Version (`304` when unchanged).
3. `GET /v3/c/{clientToken}/{lang}/{version}`: the Catalog (strings, FAQs and running experiments in one document), **only when the version changed**. A stale version answers `302` to the current one.

Edits reach Devices within about 65 s. The SDK checks `/current` on start-up, on returning to the foreground and from `startPeriodicSync`, never more often than every 60 s.

### Changed

- **Client Token in the URL path.** Use the App's Client Token (`sb_...`). It is percent-encoded as a path segment, never sent as a header. Client Tokens are public by design.
- **`Device-ID` header on every request** (the API answers `400` without it), including after redirects: the SDK follows `302`s itself, same origin only.
- **Device-ID** is a random UUID generated once per install and stored in UserDefaults (`sb_device_id`, the same key as 2.x, so upgrading keeps the Device's experiment buckets). UserDefaults rather than the Keychain because a Device is one *installation*: Keychain items survive reinstalling. `providedDeviceId` still overrides it; the override is no longer persisted.
- **Experiments are bucketed on the Device.** The Catalog carries running experiments; the SDK computes the variant deterministically (SHA-256 of `deviceId + experimentId`, identical on every platform and to the retired server assignment). The server never assigns variants or records exposures.
- **FAQs come from the Catalog.** One download per language serves strings and FAQs; `FAQProvider` shares `StringProvider`'s configuration and sync.
- **Storage.** The last Catalog of each language is a JSON file in `Application Support/Stringboot/v3/catalogs` (excluded from backup), replaced atomically together with its version. Core Data is no longer used.
- **Errors.** `401 invalid_token` stops syncing (stored Catalogs stay in use) until `initialize` is called again, and publishes a clear `initializationError`. `404` on `/current` (language deactivated) falls back to the App's default language. Offline, `5xx` and `429` keep the stored Catalog and retry with exponential backoff (honouring `Retry-After`).
- `refreshFromNetwork(lang:forceRefresh:)` revalidates with `/current`; `forceRefresh` no longer re-downloads an unchanged Catalog (Catalogs are immutable per version).
- `startPeriodicSync(interval:)` raises intervals below 60 s to 60 s.
- `publisher(for:lang:)` now re-emits after every Catalog change.
- `ActiveLanguage` decodes the v3 `/languages` shape and gains `nativeName`, `direction` and `isRightToLeft`.
- `FAQ.appId`, `createdAt` and `updatedAt` are always nil and `deleted` is always false (the Device API doesn't send them).
- URLSession: ephemeral configuration, no HTTP cache (the SDK stores Catalogs itself), fails fast when offline instead of waiting for connectivity.

### Added

- `StringbootAnalyticsHandler.onExperimentExposure(_:)` (default no-op) with `ExperimentExposure`, called the first time per process a string's value comes from an experiment variant.
- `ExperimentBucketing.bucket(deviceId:experimentId:)` and `ExperimentBucketing.variant(for:in:)`.
- `StringProvider`: `deviceId`, `defaultLanguage`, `lastSyncError`, `isTokenRejected`, `catalogVersion(lang:)`, `experimentAssignments(lang:)`, `getCached(_:lang:)`, `stopPeriodicSync()`.
- `initialize(..., enableCertificatePinning:)` on `StringProvider`.
- `Catalog`, `CatalogFAQ`, `CatalogExperiment`, `CatalogVariant`, `LanguagesResponse`, `DeviceAPIResult`, `DeviceAPIError`, `DownloadedCatalog`.
- `StringbootSDKInfo.version` (`3.0.0`), also sent in the `User-Agent`.
- Unit tests (`swift test`).

### Removed

- `FAQSyncClient`, `StringbootDatabase`, `FAQDatabase`, `CachedString`, `CachedFAQEntity` (Core Data persistence).
- Old wire models: `ApiResponse`, `ApiResult`, `MetaData`, `MetaMetadata`, `CatalogData`, `CatalogMetadata`, `DeltaUpdatesResponse`, `StringUpdate`, `HealthResponse`, `FAQMetaResponse`, `FAQMetaData`, `FAQMetadataObject`, `FAQDeltaResponse`, `FAQDeltaData`, `FAQUpdate`, `FAQCatalogResponse`, `FAQCatalogData`, `FAQCatalogMetadata`, `FAQApiResult`.
- `StringbootAPI`'s old methods (`getStringsMeta`, `getStringsUpdates`, `getFullStringCatalog`, `getActiveLanguages`, `getDefaultLanguage`, `getLanguage`, `getLanguageMap`, `checkHealth`). Its replacements are `getLanguages()`, `getCurrentVersion(language:knownVersion:)` and `getCatalog(language:version:)`; its initializer now takes `deviceId:`.
- Delta sync, ETag/fingerprint metadata, server-side experiment assignment, and per-string access counters in UserDefaults.

### Upgrading an installed app

On first launch, 3.0 migrates once and never crashes doing it:

- The 2.x Core Data cache (`StringbootCache.sqlite`) is opened read-only. Each language's strings and FAQs become a Catalog with version `-1`, served offline until the first successful sync replaces it. The old store is then deleted. If the store can't be read, it is discarded and the app starts like a fresh install (bundle strings until the first sync).
- Obsolete UserDefaults keys (`sb_etag_*`, `sb_last_sync_*`, `sb_last_fetch_*`, `sb_last_faq_fetch_*`, `sb_access_*`, `sb_last_access_*`, `sb_experiments`, `sb_available_languages`) are removed. `sb_device_id` and `com.stringboot.currentLanguage` are kept.

See the "Migrating from 2.x" section of [README.md](README.md) for the code changes.
