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
            checksum: "b64497bb8366c827c3b64a6630c53ec81763ec9ac3af2cfa1862d3ec572a900e"
        )
    ]
)

