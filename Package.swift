// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StringbootSDK",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "StringbootSDK",
            targets: ["StringbootSDK"]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "StringbootSDK",
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/v1.2.1/StringbootSDK.xcframework.zip",
            checksum: "b044aa10d933c93b97ad9f1c972fec4357ed99b18fa245e610881c1a4a57a4e3"
        )
    ]
)

