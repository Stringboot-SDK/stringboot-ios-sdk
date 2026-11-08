// swift-tools-version: 5.9
// Stringboot iOS SDK: binary Swift package (StringbootSDK.xcframework, signed by
// Zilitone Technologies Private Limited, team WLS72CNBGH). Source and docs: https://docs.stringboot.com/ios-sdk
import PackageDescription

let package = Package(
    name: "StringbootSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
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
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/3.0.1/StringbootSDK.xcframework.zip",
            checksum: "0f4bd8e918964ceca3b52a8ce27ee466f9ee2303267396a4888bb7b2d6a1c9ad"
        )
    ]
)
