// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calculator",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "Calculator",
            type: .dynamic,
            targets: ["Calculator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.53.0"))
    ],
    targets: [
        .target(
            name: "Calculator",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Calculator"],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
    ]
)
