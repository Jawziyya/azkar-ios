// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ArticleReader", targets: ["ArticleReader"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.0.0"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
        .package(url: "https://github.com/onmyway133/RoughSwift", from: "2.0.0"),
    ],
    targets: [
        .target(name: "ArticleReader", dependencies: [
            .product(name: "Entities", package: "Core"),
            .product(name: "Perception", package: "swift-perception"),
            "Fakery",
            "RoughSwift",
            .product(name: "NukeUI", package: "Nuke"),
        ]),
    ]
)
