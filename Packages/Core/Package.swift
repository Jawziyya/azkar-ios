// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Entities", targets: ["Entities"]),
        .library(name: "Library", targets: ["Library"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
        .package(url: "https://github.com/groue/GRDB.swift", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "Extensions",
            dependencies: [
                "Alamofire"
            ]
        ),
        .target(
            name: "Entities",
            dependencies: [
                "Fakery",
            ]
        ),
        .target(
            name: "Library",
            dependencies: [
                "Entities",
                "Extensions",
                .product(name: "GRDB", package: "GRDB.swift"),
            ]
        ),
    ]
)
