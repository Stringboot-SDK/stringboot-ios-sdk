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
            checksum: "6757b36f28f5f0ee59b5d8ca656d50dfbd0cd9f290b480a181fd8221e81ecaf1"
        )
    ]
)
