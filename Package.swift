// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnnotationInject",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "AnnotationInject",
            targets: ["AnnotationInject"]),
        .executable(name: "annotationinject-cli", targets: ["AnnotationCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.4.0"),
        .package(url: "https://github.com/krzysztofzablocki/Sourcery", from: "0.16.2"),
        .package(url: "https://github.com/Quick/Nimble", from: "8.0.2"),
        .package(url: "https://github.com/Quick/Quick", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "AnnotationInject",
            dependencies: [
                "Swinject",
                .product(name: "SourceryRuntime", package: "Sourcery")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "AnnotationInjectTests",
            dependencies: ["AnnotationInject", "Quick", "Nimble"],
            path: "Tests"
        ),
        .target(
            name: "AnnotationCLI",
            dependencies: [],
            path: "CLI",
            resources: [
                .copy("Templates"),
                .copy("Scripts"),
                .copy("Sources")
            ]
        )
    ]
)
