# Stringboot iOS SDK

> High-performance internationalization (i18n) SDK for iOS implementing the String-Sync v2 protocol

The Stringboot iOS SDK provides a sophisticated multi-layered caching system with smart memory management, offline support, and network synchronization to minimize API calls and provide fast string lookups.

## Features

- ✅ **Smart Caching** - LRU cache with language-aware and frequency-based eviction
- ✅ **Offline Support** - Full functionality without network via Core Data
- ✅ **SwiftUI Integration** - Native property wrappers and view modifiers
- ✅ **UIKit Integration** - Extensions and custom components with automatic updates
- ✅ **Memory Management** - Automatic cache size adjustment and memory pressure handling
- ✅ **Network Optimization** - ETag-based conditional requests for bandwidth optimization
- ✅ **Integrity Verification** - SHA-256 verification of network responses
- ✅ **Reactive Updates** - Combine publishers for real-time UI updates

## Requirements

- iOS 14.0+ / macOS 11.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk-binary.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/Stringboot-SDK/stringboot-ios-sdk-binary.git`
3. Select version and add to your target

## Quick Start

### 1. Initialize the SDK

In your `App` or `AppDelegate`:

```swift
import StringbootSDK

// In SwiftUI App
@main
struct MyApp: App {
    init() {
        StringProvider.shared.initialize(
            cacheSize: 1000,
            apiToken: "YOUR_API_TOKEN",
            baseURL: "https://api.stringboot.com"
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. SwiftUI Usage

```swift
import SwiftUI
import StringbootSDK

struct ContentView: View {
    @StateObject private var languageManager = StringbootLanguageManager()
    @State private var selectedLanguage = "en"

    var body: some View {
        VStack {
            // Using SBText (automatic localization)
            SBText("welcome_message", lang: selectedLanguage)
                .font(.title)

            // Language picker
            Picker("Language", selection: $selectedLanguage) {
                ForEach(languageManager.availableLanguages, id: \.code) { lang in
                    Text(lang.name).tag(lang.code)
                }
            }
            .onChange(of: selectedLanguage) { newLang in
                languageManager.setLanguage(newLang)
            }
        }
    }
}
```

### 3. UIKit Usage

```swift
import UIKit
import StringbootSDK

class ViewController: UIViewController {
    let titleLabel = SBLabel(key: "welcome_message")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Auto-updates on language change
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(titleLabel)
    }

    @objc func changeLanguage() {
        StringbootLanguageNotifier.shared.changeLanguage(to: "es")
        // All SBLabel instances will update automatically
    }
}
```

## API Overview

### StringProvider

Main entry point for the SDK:

```swift
// Initialization
StringProvider.shared.initialize(
    cacheSize: 1000,
    apiToken: "YOUR_API_TOKEN",
    baseURL: "https://api.stringboot.com"
)

// String access
let text = await StringProvider.shared.get("welcome_message", lang: "en")

// Language management
StringProvider.shared.setLocale("es")
let languages = await StringProvider.shared.getAvailableLanguagesFromServer()

// Cache management
StringProvider.shared.clearMemoryCache()
let stats = StringProvider.shared.getCacheStats()
```

### SwiftUI Components

```swift
// Text view
SBText("key", lang: "en")

// Property wrapper
@StringbootString("welcome_message")
var welcomeText: String

// Language manager
@StateObject var languageManager = StringbootLanguageManager()
```

### UIKit Components

```swift
// Custom labels and buttons
let label = SBLabel(key: "welcome_message")
let button = SBButton(key: "button_text")

// Extensions
label.setStringboot(key: "text", lang: "en")
button.setStringbootTitle(key: "button", for: .normal, lang: "en")
```

## Configuration

### Logging

Control SDK logging:

```swift
// Disable logs in production
StringbootLogger.isLoggingEnabled = false

// Set log level
StringbootLogger.logLevel = .debug
```

### Memory Management

Handle memory pressure:

```swift
StringProvider.shared.handleMemoryPressure(level: .critical)
```

## Performance

- ≤2 network requests per cold start (P95)
- <300ms strings ready in memory on 4G
- <2kB download when nothing changed
- 100% offline functionality

## Documentation

For detailed documentation, API reference, and advanced usage:
- 📖 [API Documentation](https://docs.stringboot.com)
- 💬 [Support](mailto:support@stringboot.com)

## License

Proprietary - See LICENSE file for details

## Support

- Email: support@stringboot.com
- Issues: For SDK issues, please contact support
