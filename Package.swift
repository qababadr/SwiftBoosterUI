// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftBoosterUI",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftBoosterUI",
            targets: ["SwiftBoosterUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/LottieFiles/dotlottie-ios.git", from: "0.12.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftBoosterUI",
            dependencies: [
                .product(name: "DotLottie", package: "dotlottie-ios")
            ],
            resources: [
                .process("Media.xcassets"),
                .process("FontAssets")
            ]
        ),
        .testTarget(
            name: "SwiftBoosterUITests",
            dependencies: ["SwiftBoosterUI"]
        ),
    ]
)
