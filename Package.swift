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
                    url: "https://github.com/Bereyziat-Development/SwiftUIAdaptiveActionSheet",
                    branch: "main"
                ),
        .package(
            url: "https://github.com/Bereyziat-Development/SnapPix",
            branch: "main"
        )
    ],
    targets: [
        .target(
            name: "SpyBug",
            dependencies: ["SnapPix", "SwiftUIAdaptiveActionSheet"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "SpyBugTests",
            dependencies: ["SpyBug"]
        )
    ]
)
