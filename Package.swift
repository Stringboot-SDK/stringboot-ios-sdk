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
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/v1.0.1/StringbootSDK.xcframework.zip",
            checksum: "0a1a96d07d8816d7cbc09f30e3dc3aecfeee097325d96fd15cebf7030ea1539e"
        )
    ]
)
