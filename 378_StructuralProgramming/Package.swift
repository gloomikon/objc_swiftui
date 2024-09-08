// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main")
    ],
    targets: [
        .macro(
            name: "StructuralProgrammingMacros",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "StructuralProgramming",
            dependencies: [
                "StructuralProgrammingMacros"
            ]   
        ),
        .testTarget(
            name: "StructuralProgrammingTests",
            dependencies: ["StructuralProgramming"]
        )
    ]
)
