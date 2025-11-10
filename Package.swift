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
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/v1.0.0/StringbootSDK.xcframework.zip",
            checksum: "32888e363bdfa61903f768135ee6198511dc31d4e640f4be7edb408d8b4a7982"
        )
    ]
)
