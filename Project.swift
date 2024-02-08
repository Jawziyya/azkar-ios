import ProjectDescription
import Foundation

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

private func getDefaultSettings(
    bundleId: String,
    isDistribution: Bool
) -> [String: SettingValue] {
    let provisioningProfileType = isDistribution ? "AppStore" : "Development"
    return [
        "ASSETCATALOG_COMPILER_INCLUDE_ALL_APPICON_ASSETS": "YES",
        "CODE_SIGN_IDENTITY": isDistribution ? "iPhone Distribution" : "iPhone Developer",
        "CODE_SIGN_IDENTITY[sdk=macosx*]": isDistribution ? "Apple Distribution" : "Mac Developer",
        "PROVISIONING_PROFILE_SPECIFIER": "match \(provisioningProfileType) \(bundleId)",
        "PROVISIONING_PROFILE_SPECIFIER[sdk=macosx*]": "match \(provisioningProfileType) \(bundleId) catalyst",
    ]
}

let packages: [Package] = [
    // MARK: Internal depedencies.
    .local(path: AzkarPackage.audioPlayer.path),
    .local(path: AzkarPackage.core.path),
    .local(path: AzkarPackage.features.path),

    // MARK: Services.
    .remote(url: "https://github.com/RevenueCat/purchases-ios.git", requirement: .upToNextMajor(from: "4.19.0")),

    // MARK: Network.
    .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),

    // MARK: Utilities.
    .remote(url: "https://github.com/weichsel/ZIPFoundation", requirement: .upToNextMajor(from: "0.9.0")),
    .remote(url: "https://github.com/bizz84/SwiftyStoreKit", requirement: .upToNextMajor(from: "0.16.3")),
    .remote(url: "https://github.com/SwapnanilDhol/IGStoryKit", requirement: .upToNextMajor(from: "1.1.1")),

    // MARK: UI.
    .remote(url: "https://github.com/radianttap/Coordinator", requirement: .upToNextMajor(from: "6.4.2")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "3.0.0")),
    .remote(url: "https://github.com/SwiftUIX/SwiftUIX", requirement: .upToNextMajor(from: "0.1.3")),
    .remote(url: "https://github.com/SwiftUI-Plus/ActivityView", requirement: .upToNextMajor(from: "1.0.0")),
    .remote(url: "https://github.com/demharusnam/SwiftUIDrag", requirement: .revision("0686318a")),
    .remote(url: "https://github.com/aheze/Popovers", requirement: .upToNextMajor(from: "1.3.2")),
    .remote(url: "https://github.com/SvenTiigi/WhatsNewKit", requirement: .upToNextMajor(from: "2.0.0")),
    .remote(url: "https://github.com/rundfunk47/stinsen", requirement: .upToNextMajor(from: "2.0.0")),
    .remote(url: "https://github.com/supabase-community/supabase-swift", requirement: .upToNextMajor(from: "2.0.0")),
]

let baseSettingsDictionary = SettingsDictionary()
    .bitcodeEnabled(false)
    .merging([kDevelopmentTeam: SettingValue(stringLiteral: teamId)])

    // A workaround due https://bugs.swift.org/browse/SR-11564
    // Should be removed when the bug is resolved.
    .merging([kDeadCodeStripping: SettingValue(booleanLiteral: false)])

let settings = Settings.settings(
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
    case azkarWidgets = "Widgets"
    case azkarAppTests = "AzkarTests"
    case azkarAppUITests = "AzkarUITests"

    var bundleId: String {
        switch self {
        case .azkarApp: return baseDomain + ".azkar-app"
        case .azkarWidgets: return baseDomain + ".azkar-app.widgets"
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
                entitlements: "Azkar/Azkar.entitlements",
                scripts: [
                    .post(path: "./scripts/swiftlint.sh", name: "SwiftLint")
                ],
                dependencies: [
                    .target(name: "AzkarWidgets"),
                    .package(product: "Entities"),
                    .package(product: "Extensions"),
                    .package(product: "Library"),
                    .package(product: "ArticleReader"),
                    .package(product: "AudioPlayer"),
                    .package(product: "SwiftyStoreKit"),
                    .package(product: "Coordinator"),
                    .package(product: "Lottie"),
                    .package(product: "Alamofire"),
                    .package(product: "ZIPFoundation"),
                    .package(product: "NukeUI"),
                    .package(product: "RevenueCat"),
                    .package(product: "SwiftUIX"),
                    .package(product: "ActivityView"),
                    .package(product: "SwiftUIDrag"),
                    .package(product: "Popovers"),
                    .package(product: "WhatsNewKit"),
                    .package(product: "IGStoryKit"),
                    .package(product: "Stinsen"),
                    .package(product: "Supabase"),
                ],
                settings: Settings.settings(
                    base: baseSettingsDictionary
                        .merging(["DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO"])
                    ,
                    configurations: [
                        .debug(
                            name: "Debug",
                            settings: getDefaultSettings(
                                bundleId: "io.jawziyya.azkar-app",
                                isDistribution: false
                            ),
                            xcconfig: "./Azkar.xcconfig"
                        ),
                        .release(
                            name: "Release",
                            settings: getDefaultSettings(
                                bundleId: "io.jawziyya.azkar-app",
                                isDistribution: true
                            ),
                            xcconfig: "./Azkar.xcconfig"
                        )
                    ]
                )
            )
            
        case .azkarWidgets:
            return Target(
                name: "AzkarWidgets",
                platform: .iOS,
                product: .appExtension,
                bundleId: bundleId,
                deploymentTarget: deploymentTarget,
                infoPlist: .file(path: "AzkarWidgets/Info.plist"),
                sources: [
                    "AzkarWidgets/Sources/**",
                    "Azkar/Sources/Generated/Strings+Generated.swift",
                ],
                resources: [
                    "AzkarWidgets/Resources/**",
                    "Azkar/Resources/azkar.db",
                    "Azkar/Resources/ru.lproj/Localizable.strings",
                    "Azkar/Resources/ru.lproj/Localizable.stringsdict",
                    "Azkar/Resources/en.lproj/Localizable.strings",
                    "Azkar/Resources/en.lproj/Localizable.stringsdict",
                ],
                entitlements: "AzkarWidgets/AzkarWidgets.entitlements",
                dependencies: [
                    .package(product: "Entities"),
                    .package(product: "Extensions"),
                    .package(product: "Library"),
                ],
                settings: Settings.settings(
                    base: baseSettingsDictionary
                        .merging(["DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO"])
                    ,
                    configurations: [
                        .debug(
                            name: "Debug",
                            settings: getDefaultSettings(
                                bundleId: "io.jawziyya.azkar-app.widgets",
                                isDistribution: false
                            )
                        ),
                        .release(
                            name: "Release",
                            settings: getDefaultSettings(
                                bundleId: "io.jawziyya.azkar-app.widgets",
                                isDistribution: true
                            )
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
                settings: Settings.settings(
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
                settings: Settings.settings(
                    base: baseSettingsDictionary
                ),
                launchArguments: []
            )
        }
    }
}

enum AzkarPackage: String {
    case core = "Core"
    case audioPlayer = "AudioPlayer"
    case features = "Features"

    var name: String { rawValue }

    var path: Path {
        return "Packages/\(name)"
    }
}

let project = Project(
    name: projectName,
    organizationName: companyName,
    options: .options(
        developmentRegion: "en",
        disableSynthesizedResourceAccessors: true
    ),
    packages: packages,
    settings: settings,
    targets: AzkarTarget.allCases.map(\.target),
    schemes: [
        Scheme(
            name: AzkarTarget.azkarApp.rawValue,
            shared: true,
            buildAction: BuildAction(targets: ["Azkar"]),
            runAction: RunAction.runAction(
                executable: "Azkar",
                arguments: Arguments(
                    environment: [
                        "SUPABASE_API_URL": ProcessInfo.processInfo.environment["SUPABASE_API_URL"]!,
                        "SUPABASE_API_KEY": ProcessInfo.processInfo.environment["SUPABASE_API_KEY"]!,
                    ]
                )
            )
        ),
        Scheme(
            name: AzkarTarget.azkarAppUITests.rawValue,
            shared: true,
            buildAction: BuildAction(targets: ["AzkarUITests"]),
            testAction: TestAction.targets(["AzkarUITests"]),
            runAction: RunAction.runAction(executable: "Azkar")
        )
    ],
    additionalFiles: []
)
