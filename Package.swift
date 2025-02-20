// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "FirebaseAuth": .staticFramework,
            "FirebaseFirestore": .staticFramework,
            "FirebaseStorage": .staticFramework,

            "RevenueCat": .staticFramework,
            "SuperwallKit": .staticFramework,

            "ZIPFoundation": .staticFramework,

            "Alamofire": .staticFramework,
            "IGStoryKit": .staticFramework,
            "SwiftUIX": .staticFramework,
            "SwiftUIDrag": .staticFramework,
            "SwiftyStoreKit": .staticFramework,
            "WhatsNewKit": .staticFramework,
        ]
    )

#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(path: "Packages/Modules"),
        
        // MARK: Data
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.0"),
        
        // MARK: Services.
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.3.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", from: "4.19.0"),
        .package(url: "https://github.com/superwall/Superwall-iOS", from: "3.0.0"),
                
        // MARK: Utilities.
        .package(url: "https://github.com/SwapnanilDhol/IGStoryKit", from: "1.1.1"),
        .package(url: "https://github.com/bizz84/SwiftyStoreKit", from: "0.16.3"),
        
        // MARK: UI.
        .package(url: "https://github.com/SwiftUIX/SwiftUIX", from: "0.2.2"),
        .package(url: "https://github.com/demharusnam/SwiftUIDrag", revision: "0686318a"),
        .package(url: "https://github.com/SvenTiigi/WhatsNewKit", from: "2.0.0"),
    ],
    targets: [
    ]
)
