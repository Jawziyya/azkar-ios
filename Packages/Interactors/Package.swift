// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Interactors",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "DatabaseInteractors", targets: ["DatabaseInteractors"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        
        // MARK: Data
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3"),
    ],
    targets: [
        .target(
            name: "DatabaseInteractors",
            dependencies: [
                .product(name: "Entities", package: "Core"),
                .product(name: "Extensions", package: "Core"),
                .product(name: "AzkarServices", package: "Core"),
                .product(name: "GRDB", package: "GRDB.swift"),
            ]
        ),
    ]
)
