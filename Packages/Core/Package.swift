// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Core",
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
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "Entities",
            dependencies: [
                "Fakery",
            ]
        ),
    ]
)
