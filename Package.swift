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
            checksum: "1cb263030142f3ebd1eb9a575ea53fd52bc33d2712b465cd26d024127ad23ec8"
        )
    ]
)

