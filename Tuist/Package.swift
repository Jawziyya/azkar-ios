// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "SuperwallKit": .staticLibrary,
        ]
    )
#endif

let package = Package(
    name: "Azkar",
    dependencies: [
        .package(path: "../Packages/Core"),
        .package(path: "../Packages/Interactors"),
        .package(path: "../Packages/Modules"),
        
        // MARK: Data
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.0"),
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3"),
        
        // MARK: Services.
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.3.0"),
        .package(url: "https://github.com/supabase-community/supabase-swift", from: "2.0.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.19.0"),
        .package(url: "https://github.com/superwall-me/Superwall-iOS", from: "4.0.0"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift", from: "2.8.0"),
        
        // MARK: Network.
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.8.0"),
        
        // MARK: Utilities.
        .package(url: "https://github.com/rundfunk47/stinsen", from: "2.0.0"),
        .package(url: "https://github.com/vadymmarkov/Fakery", from: "5.1.0"),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit", from: "0.16.3"),
        .package(url: "https://github.com/kean/Nuke", from: "12.0.0"),
        .package(url: "https://github.com/onmyway133/RoughSwift", from: "2.0.0"),
        
        // MARK: UI.
        .package(url: "https://github.com/aheze/Popovers", from: "1.3.2"),
        .package(url: "https://github.com/airbnb/lottie-spm", from: "4.5.0"),
        .package(url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.2.2"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.1.2"),
        .package(url: "https://github.com/shaps80/SwiftUIBackports", from: "2.8.1"),
        .package(url: "https://github.com/SvenTiigi/WhatsNewKit", from: "2.0.0"),
        .package(url: "https://github.com/bmoliveira/MarkdownKit", from: "1.7.1"),
    ],
    targets: [
    ]
)
