// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "AzkarResources", targets: ["AzkarResources"]),
        .library(name: "Entities", targets: ["Entities"]),
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "AzkarServices", targets: ["AzkarServices"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "AzkarResources",
            dependencies: []
        ),
        .target(
            name: "Entities",
            dependencies: [
                "Fakery",
            ]
        ),
        .target(
            name: "Extensions",
            dependencies: [
            ]
        ),
        .target(
            name: "AzkarServices",
            dependencies: [
                "Entities",
            ]
        ),
    ]
)
