// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnnotationInject",
    platforms: [
        .macOS(.v10_11)
    ],
    products: [
        .library(
            name: "AnnotationInject",
            targets: ["AnnotationInject"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.4.0"),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery", from: "0.16.2"),
        .package(url: "https://github.com/Quick/Nimble", from: "8.0.2"),
        .package(url: "https://github.com/Quick/Quick", from: "2.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AnnotationInject",
            dependencies: ["Swinject", "SourceryRuntime"],
            path: "Sources",
            resources: [
                .copy("Templates"),
                .copy("Scripts")
            ]),
        .testTarget(
            name: "AnnotationInjectTests",
            dependencies: ["AnnotationInject", "Quick", "Nimble"],
            path: "Tests"
        )
    ]
)
