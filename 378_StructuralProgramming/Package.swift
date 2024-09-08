// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StructuralProgramming",
    platforms: [
        .macOS(.v13),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "StructuralProgramming",
            targets: ["StructuralProgramming"]
        ),
    ],
    targets: [
        .target(
            name: "StructuralProgramming"
        ),
        .testTarget(
            name: "StructuralProgrammingTests",
            dependencies: ["StructuralProgramming"]
        )
    ]
)
