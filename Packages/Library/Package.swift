// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Library",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Library",
            targets: ["Library"]
        ),
    ],
    dependencies: [
        .package(path: "../Entities"),
        .package(url: "https://github.com/groue/GRDB.swift", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "Library",
            dependencies: [
                "Entities",
                .product(name: "GRDB", package: "GRDB.swift"),
            ]
        ),
    ]
)
