# Stringboot iOS SDK

Update your app's strings, FAQs and A/B-tested copy from the [Stringboot](https://stringboot.com)
dashboard, without an App Store release.

- **Offline-first:** the stored Catalog is shown instantly and without a network connection; updates sync in the background.
- **Edits reach running apps within about two minutes**, usually much sooner, and every app on its next launch.
- **SwiftUI and UIKit:** `SBText`, `@StringbootString`, `SBLabel`, `SBButton`, plus async/await and Combine APIs.
- **FAQs** with Markdown answers rendered as native rich text (raw HTML is never interpreted).
- **A/B tests** bucketed on the device; the same Device-ID gets the same variant on iOS, Android and the web.

Full documentation: **https://docs.stringboot.com/ios-sdk**

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 27 or later (the framework is built with Xcode 27.2)
- A Client Token (`sb_…`) from the [Stringboot dashboard](https://dashboard.stringboot.com/tokens)

## Installation (Swift Package Manager)

In Xcode: **File → Add Package Dependencies…**, enter

```
https://github.com/Stringboot-SDK/stringboot-ios-sdk
```

and choose **Up to Next Major Version** from `3.0.1`. Xcode embeds the framework automatically.

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk", from: "3.0.1")
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [.product(name: "StringbootSDK", package: "stringboot-ios-sdk")]
    )
]
```

This repository distributes the SDK as a signed binary (`StringbootSDK.xcframework`, signed by
Zilitone Technologies Private Limited, team `WLS72CNBGH`). Manual installation: download
`StringbootSDK.xcframework.zip` from the [releases](https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases),
drag `StringbootSDK.xcframework` into your target and choose **Embed & Sign**.

## Quick start

```swift
import SwiftUI
import StringbootSDK

@main
struct MyApp: App {
    init() {
        StringProvider.shared.initialize(
            apiToken: "sb_your_client_token",
            baseURL: "https://api.stringboot.com"
        )
        StringProvider.shared.startPeriodicSync()   // checks for edits every 60 s while in the foreground
    }

    var body: some Scene {
        WindowGroup {
            SBText("welcome_message")               // updates when the Catalog changes
        }
    }
}
```

```swift
// async/await
let title = await StringProvider.shared.get("welcome_message", lang: "en")
```

**Language:** the SDK starts in the language the user last chose (`setLocale` / `StringbootLanguageManager`,
persisted), otherwise the device's preferred language if the App has it, otherwise the App's default
language. A key missing from the current language falls back to the default language.

See the [documentation](https://docs.stringboot.com/ios-sdk) for UIKit, languages, FAQs, A/B tests,
certificate pinning and troubleshooting.

## Privacy

The SDK includes a privacy manifest (`PrivacyInfo.xcprivacy`): it uses UserDefaults (reason
CA92.1) and stores a random Device ID, declared as collected, not linked to the user and not used
for tracking, for app functionality. Reflect the Device ID in your app's App Store privacy details.

## Upgrading from 2.x

3.0 is a required upgrade: the API that SDK 1.x/2.x used now answers `426 Upgrade Required`, so
those apps receive no more updates. Cached strings and the Device-ID are migrated automatically.
See [Upgrading](https://docs.stringboot.com/ios-sdk/upgrading) and the [CHANGELOG](CHANGELOG.md).

## Support

- Documentation: https://docs.stringboot.com
- Issues and questions: [GitHub Issues](https://github.com/Stringboot-SDK/stringboot-ios-sdk/issues) or developer@stringboot.com

## License

MIT. See [LICENSE](LICENSE).
