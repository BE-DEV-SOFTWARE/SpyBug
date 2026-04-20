// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpyBug",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .visionOS(.v1), .macOS(.v14)],
    products: [
        .library(
            name: "SpyBug",
            targets: ["SpyBug"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SpyBug",
            resources: [.process("Media.xcassets")]
        )
    ]
)
