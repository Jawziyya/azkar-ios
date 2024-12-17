// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Entities", targets: ["Entities"]),
        .library(name: "Library", targets: ["Library"]),
        .library(name: "AboutApp", targets: ["AboutApp"]),
        .library(name: "ArticleReader", targets: ["ArticleReader"]),
        .library(name: "AudioPlayer", targets: ["AudioPlayer"]),
        .library(name: "ZikrCollectionsOnboarding", targets: ["ZikrCollectionsOnboarding"]),
    ],
    dependencies: [
        // MARK: Data
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.0"),
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3"),
        
        // MARK: Services.
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.3.0"),
        .package(url: "https://github.com/supabase-community/supabase-swift", from: "2.0.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.19.0"),
        
        // MARK: Network.
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        
        // MARK: Utilities.
        .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.0.0"),
        .package(url: "https://github.com/rundfunk47/stinsen", from: "2.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit", from: "0.16.3"),
        .package(url: "https://github.com/SwapnanilDhol/IGStoryKit", from: "1.1.1"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
        .package(url: "https://github.com/onmyway133/RoughSwift", from: "2.0.0"),
        
        // MARK: UI.
        .package(url: "https://github.com/aheze/Popovers", from: "1.3.2"),
        .package(url: "https://github.com/radianttap/Coordinator", from: "6.4.2"),
        .package(url: "https://github.com/airbnb/lottie-ios", from: "3.0.0"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.2.2"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.1.2"),
        .package(url: "https://github.com/shaps80/SwiftUIBackports", from: "2.8.1"),
        .package(url: "https://github.com/demharusnam/SwiftUIDrag", revision: "0686318a"),
        .package(url: "https://github.com/SvenTiigi/WhatsNewKit", from: "2.0.0"),
        .package(url: "https://github.com/bmoliveira/MarkdownKit", from: "1.7.1"),
    ],
    targets: [
        .target(
            name: "AudioPlayer",
            dependencies: []
        ),
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
                .product(name: "Supabase", package: "supabase-swift"),
                .product(name: "NukeUI", package: "Nuke"),
                "SwiftUIBackports",
            ]
        ),
        .target(name: "ArticleReader", dependencies: [
            "Entities",
            "Extensions",
            "RoughSwift",
            "Popovers",
            "MarkdownKit",
            .product(name: "Perception", package: "swift-perception"),
            .product(name: "Fakery", package: "Fakery"),
            .product(name: "NukeUI", package: "Nuke"),
        ]),
        .target(name: "AboutApp", dependencies: [
            "Entities",
            "Extensions",
            "Library",
            .product(name: "SwiftUIBackports", package: "SwiftUIBackports"),
            .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
        ]),
        .target(name: "ZikrCollectionsOnboarding", dependencies: [
            "Entities",
            "Library",
        ])
    ]
)
