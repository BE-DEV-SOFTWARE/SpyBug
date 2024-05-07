// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpyBug",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SpyBug",
            targets: ["SpyBug"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Bereyziat-Development/AdaptiveSheet",
            exact: "0.2.0"
        ),
        .package(
            url: "https://github.com/Bereyziat-Development/SnapPix",
            exact: "0.1.1"
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
