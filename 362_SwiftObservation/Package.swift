// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftObservation",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftObservation",
            targets: ["SwiftObservation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .macro(
            name: "SwiftObservationMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "SwiftObservation",
            dependencies: [
                "SwiftObservationMacros"
            ]
        ),
        .testTarget(
            name: "SwiftObservationTests",
            dependencies: ["SwiftObservation"]),
    ]
)
