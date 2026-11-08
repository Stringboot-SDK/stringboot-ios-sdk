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
            url: "https://github.com/Stringboot-SDK/stringboot-ios-sdk/releases/download/3.0.0/StringbootSDK.xcframework.zip",
            checksum: "ccb6304c64e2fc7e8ea99b9804bec7892a9dab593311d39fe695b8e2d8b0cfe7"
        )
    ]
)
