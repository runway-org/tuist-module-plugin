// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "tuist-module-description",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "ModuleDescription",
            targets: ["ModuleDescription"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/tuist/projectdescription", from: "3.22.0"),
    ],
    targets: [
        .target(
            name: "ModuleDescription",
            dependencies: [
                .product(name: "ProjectDescription", package: "ProjectDescription"),
            ],
            path: "ProjectDescriptionHelpers"
        ),
        .testTarget(
            name: "ModuleDescriptionTests",
            dependencies: ["ModuleDescription"],
            path: "Tests"
        ),
    ]
)
