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
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/v1.2.0/StringbootSDK.xcframework.zip",
            checksum: "575d75ff8281a04914d4adef2914f46ca94cb0be993598d99fe9446e6522a83a"
        )
    ]
)
