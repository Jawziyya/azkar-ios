// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Entities",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Entities",
            targets: ["Entities"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Entities",
            dependencies: []
        ),
    ]
)
