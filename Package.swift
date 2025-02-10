// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpyBug",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .visionOS(.v1)],
    products: [
        .library(
            name: "SpyBug",
            targets: ["SpyBug"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/BE-DEV-SOFTWARE/AdaptiveSheet",
            exact: "0.2.0"
        ),
        .package(
            url: "https://github.com/BE-DEV-SOFTWARE/SnapPix",
            exact: "0.1.2"
        )
    ],
    targets: [
        .target(
            name: "SpyBug",
            dependencies: ["SnapPix", "AdaptiveSheet"],
            resources: [.process("Media.xcassets")]
        )
    ]
)
