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
    .local(path: "Packages/Modules"),
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

let deploymentTarget = DeploymentTargets.iOS("15.0")

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
            return Target.target(
                name: rawValue,
                destinations: .iOS,
                product: .app,
                bundleId: bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: .file(path: "\(rawValue)/Info.plist"),
                sources: "Azkar/Sources/**",
                resources: "Azkar/Resources/**",
                entitlements: "Azkar/Azkar.entitlements",
                scripts: [
                    .post(path: "./scripts/swiftlint.sh", name: "SwiftLint")
                ],
                dependencies: [
                    .target(name: "AzkarWidgets"),
                    
                    .external(name: "Entities"),
                    .external(name: "Extensions"),
                    .external(name: "AzkarServices"),
                    .external(name: "Library"),
                    .external(name: "Components"),
                    .external(name: "AboutApp"),
                    .external(name: "ArticleReader"),
                    .external(name: "ZikrCollectionsOnboarding"),
                    .external(name: "AudioPlayer"),
                    
                    .external(name: "SwiftyStoreKit"),
                    .external(name: "Lottie"),
                    .external(name: "Alamofire"),
                    .external(name: "NukeUI"),
                    .external(name: "RevenueCat"),
                    .external(name: "SwiftUIX"),
                    .external(name: "SwiftUIBackports"),
                    .external(name: "Popovers"),
                    .external(name: "WhatsNewKit"),
                    .external(name: "Stinsen"),
                    .external(name: "Supabase"),
                    .external(name: "SwiftUIIntrospect"),
                    .external(name: "SuperwallKit"),
                    .external(name: "ZIPFoundation"),
                    
                    // Firebase
                    .external(name: "FirebaseCore"),
                    .external(name: "FirebaseAnalyticsWithoutAdIdSupport"),
                    .external(name: "FirebaseMessaging"),

                    .external(name: "Mixpanel"),
                ],
                settings: Settings.settings(
                    base: baseSettingsDictionary
                        .merging(["DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO"])
                        .addingObjcLinkerFlag
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
            return Target.target(
                name: "AzkarWidgets",
                destinations: .iOS,
                product: .appExtension,
                bundleId: bundleId,
                deploymentTargets: deploymentTarget,
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
                    .external(name: "Entities"),
                    .external(name: "Extensions"),
                    .external(name: "AzkarServices"),
                    .external(name: "DatabaseInteractors"),
                    .external(name: "GRDB"),
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
            return Target.target(
                name: rawValue,
                destinations: .iOS,
                product: Product.unitTests,
                productName: rawValue,
                bundleId: bundleId,
                deploymentTargets: deploymentTarget,
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
            return Target.target(
                name: rawValue,
                destinations: .iOS,
                product: Product.uiTests,
                productName: rawValue,
                bundleId: bundleId,
                deploymentTargets: deploymentTarget,
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

let project = Project(
    name: projectName,
    organizationName: companyName,
    options: .options(
        developmentRegion: "en",
        disableSynthesizedResourceAccessors: true
    ),
    settings: settings,
    targets: AzkarTarget.allCases.map(\.target),
    schemes: [
        Scheme.scheme(
            name: AzkarTarget.azkarApp.rawValue,
            shared: true,
            buildAction: .buildAction(targets: ["Azkar"]),
            runAction: RunAction.runAction(
                executable: "Azkar"
            )
        ),
        Scheme.scheme(
            name: AzkarTarget.azkarAppUITests.rawValue,
            shared: true,
            buildAction: .buildAction(targets: ["AzkarUITests"]),
            testAction: TestAction.targets(["AzkarUITests"]),
            runAction: RunAction.runAction(executable: "Azkar")
        )
    ],
    additionalFiles: []
)
