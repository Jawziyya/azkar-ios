import Foundation
import ProjectDescription

// MARK: - Constants
let kDebugSigningIdentity = "iPhone Developer"
let kReleaseSigningIdentity = "iPhone Distribution"
let kCompilationConditions = "SWIFT_ACTIVE_COMPILATION_CONDITIONS"
let kDevelopmentTeam = "DEVELOPMENT_TEAM"
let kDeadCodeStripping = "DEAD_CODE_STRIPPING"

let companyName = "Al Jawziyya"
let teamId = "486STKKP6Y"
let projectName = "Azkar"
let baseDomain = "io.jawziyya"

let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .merging([kDevelopmentTeam: SettingValue(stringLiteral: teamId)])

    // A workaround due https://bugs.swift.org/browse/SR-11564
    // Should be removed when the bug is resolved.
    .merging([kDeadCodeStripping: SettingValue(booleanLiteral: false)])

let settings = Settings(
    base: baseSettingsDictionary
)

let deploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone, .ipad, .mac])
let testsDeploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: [.iphone, .ipad, .mac])

// MARK: - Extensions
extension SettingsDictionary {
    var addingObjcLinkerFlag: Self {
        return self.merging(["OTHER_LDFLAGS": "$(inherited) -ObjC"])
    }

    func addingDevelopmentAssets(path: String) -> Self {
        return self.merging(
            ["DEVELOPMENT_ASSET_PATHS": .init(arrayLiteral: path)]
        )
    }
}

enum AzkarTarget: String, CaseIterable {
    case azkarApp = "Azkar"
    case azkarAppTests = "AzkarTests"
    case azkarAppUITests = "AzkarUITests"

    var bundleId: String {
        switch self {
        case .azkarApp: return baseDomain + ".azkar-app"
        case .azkarAppTests: return baseDomain + ".azkar-app.tests"
        case .azkarAppUITests: return baseDomain + ".azkar-app.uitests"
        }
    }

    var target: Target {
        switch self {

        case .azkarApp:
            return Target(
                name: rawValue,
                platform: .iOS,
                product: .app,
                bundleId: bundleId,
                deploymentTarget: deploymentTarget,
                infoPlist: .file(path: "\(rawValue)/Info.plist"),
                sources: "Azkar/Sources/**",
                resources: "Azkar/Resources/**",
                actions: [
                ],
                dependencies: [
                    .sdk(name: "SwiftUI.framework"),
                    .package(product: AzkarPackage.audioPlayer.name),
                    .package(product: "SwiftyStoreKit"),
                    .package(product: "Coordinator"),
                    .package(product: "Lottie"),
                    .package(product: "Introspect"),
                    .package(product: "Alamofire"),
                    .package(product: "ZIPFoundation"),
                    .package(product: "NukeUI"),
                    .package(product: "RevenueCat"),
                    .package(product: "SwiftUIX"),
                    .package(product: "ActivityView"),
                    .package(product: "SwiftUIDrag"),
                    .package(product: "Popovers"),
                    .package(product: "GRDB"),
                ],
                settings: Settings(
                    base: baseSettingsDictionary
                        .merging(["DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO"])
                    ,
                    configurations: [
                        .debug(
                            name: "Debug",
                            settings: [
                                "CODE_SIGN_IDENTITY": "iPhone Developer",
                                "CODE_SIGN_IDENTITY[sdk=macosx*]": "Mac Developer",
                                "PROVISIONING_PROFILE_SPECIFIER": "match Development io.jawziyya.azkar-app",
                                "PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]": "match Development io.jawziyya.azkar-app catalyst",
                            ],
                            xcconfig: "./Azkar.xcconfig"
                        ),
                        .release(
                            name: "Release",
                            settings: [
                                "CODE_SIGN_IDENTITY": "iPhone Distribution",
                                "CODE_SIGN_IDENTITY[sdk=macosx*]": "Apple Distribution",
                                "PROVISIONING_PROFILE_SPECIFIER": "match AppStore io.jawziyya.azkar-app",
                                "PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]": "match AppStore io.jawziyya.azkar-app catalyst",
                            ],
                            xcconfig: "./Azkar.xcconfig"
                        )
                    ]
                )
            )

        case .azkarAppTests:
            return Target(
                name: rawValue,
                platform: Platform.iOS,
                product: Product.unitTests,
                productName: rawValue,
                bundleId: bundleId,
                deploymentTarget: deploymentTarget,
                infoPlist: "AzkarTests/Info.plist",
                sources: [
                    "AzkarTests/Sources/**"
                ],
                resources: [
                ],
                dependencies: [
                    .target(name: AzkarTarget.azkarApp.rawValue),
                ],
                settings: Settings(
                    base: baseSettingsDictionary
                ),
                launchArguments: []
            )
        case .azkarAppUITests:
            return Target(
                name: rawValue,
                platform: Platform.iOS,
                product: Product.uiTests,
                productName: rawValue,
                bundleId: bundleId,
                deploymentTarget: deploymentTarget,
                infoPlist: "AzkarUITests/Info.plist",
                sources: "AzkarUITests/Sources/**",
                resources: [
                    "Azkar/Resources/en.lproj/Localizable.strings",
                    "Azkar/Resources/ru.lproj/Localizable.strings"
                ],
                dependencies: [
                    .target(name: AzkarTarget.azkarApp.rawValue),
                ],
                settings: Settings(
                    base: baseSettingsDictionary
                ),
                launchArguments: []
            )
        }
    }
}

enum AzkarPackage: String {
    case entities = "Entities"
    case databaseClient = "DatabaseClient"
    case audioPlayer = "AudioPlayer"

    var name: String { rawValue }

    var path: Path {
        return "Packages/\(name)"
    }
}

let packages: [Package] = [
    // MARK: Internal depedencies.
    .local(path: AzkarPackage.audioPlayer.path),

    // MARK: Services.
    .remote(url: "https://github.com/RevenueCat/purchases-ios.git", requirement: .revision("09c9d4d2ceb41c471d5e3110ac1a97e3de9defb4")),

    // MARK: Network.
    .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),

    // MARK: Utilities.
    .remote(url: "https://github.com/weichsel/ZIPFoundation", requirement: .upToNextMajor(from: "0.9.0")),
    .remote(url: "https://github.com/bizz84/SwiftyStoreKit", requirement: .upToNextMajor(from: "0.16.3")),
    .remote(url: "https://github.com/groue/GRDB.swift", requirement: .upToNextMajor(from: "5.0.0")),

    // MARK: UI.
    .remote(url: "https://github.com/radianttap/Coordinator", requirement: .upToNextMajor(from: "6.4.2")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "3.0.0")),
    .remote(url: "https://github.com/kean/NukeUI", requirement: .upToNextMajor(from: "0.7.0")),
    .remote(url: "https://github.com/SwiftUIX/SwiftUIX", requirement: .upToNextMajor(from: "0.1.1")),
    .remote(url: "https://github.com/siteline/SwiftUI-Introspect", requirement: .upToNextMajor(from: "0.1.3")),
    .remote(url: "https://github.com/SwiftUI-Plus/ActivityView", requirement: .upToNextMajor(from: "1.0.0")),
    .remote(url: "https://github.com/demharusnam/SwiftUIDrag", requirement: .revision("0686318a")),
    .remote(url: "https://github.com/aheze/Popovers", requirement: .upToNextMajor(from: "1.3.2")),
]

let project = Project(
    name: projectName,
    organizationName: companyName,
    packages: packages,
    settings: settings,
    targets: AzkarTarget.allCases.map(\.target),
    schemes: [
        Scheme(
            name: AzkarTarget.azkarApp.rawValue,
            shared: true,
            buildAction: BuildAction(targets: ["Azkar"]),
            runAction: RunAction(executable: "Azkar")
        ),
        Scheme(
            name: AzkarTarget.azkarAppUITests.rawValue,
            shared: true,
            buildAction: BuildAction(targets: ["AzkarUITests"]),
            testAction: TestAction(targets: ["AzkarUITests"]),
            runAction: RunAction(executable: "Azkar")
        )
    ],
    additionalFiles: []
)
