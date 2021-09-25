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

let deploymentTarget = DeploymentTarget.iOS(targetVersion: "14.0", devices: [.iphone, .ipad, .mac])
let testsDeploymentTarget = DeploymentTarget.iOS(targetVersion: "14.0", devices: [.iphone, .ipad, .mac])

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
    case audioPlayer = "AudioPlayer"

    var bundleId: String {
        switch self {
        case .azkarApp: return baseDomain + ".azkar-app"
        case .azkarAppTests: return baseDomain + ".azkar-app.tests"
        case .audioPlayer: return baseDomain + ".azkar.audio-player"
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
                    TargetAction.pre(script: "run-swiftgen.sh", name: "Run Swiftgen")
                ],
                dependencies: [
                    .sdk(name: "SwiftUI.framework"),
                    .target(name: AzkarTarget.audioPlayer.rawValue),
                    .package(product: "SwiftyMarkdown"),
                    .package(product: "SwiftRichString"),
                    .package(product: "SwiftyStoreKit"),
                    .package(product: "Coordinator"),
                    .package(product: "Lottie"),
                ],
                settings: Settings(
                    base: baseSettingsDictionary
                        .merging(["DERIVE_MACCATALYST_PRODUCT_BUNDLE_IDENTIFIER": "NO"])
                    ,
                    configurations: [
                        .debug(name: "Debug", xcconfig: "./Azkar.xcconfig"),
                        .release(name: "Release", xcconfig: "./Azkar.xcconfig")
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
                        .manualCodeSigning()
                        .codeSignIdentity("")
                ),
                launchArguments: []
            )

        case .audioPlayer:
            return Target(
                name: rawValue,
                platform: .iOS,
                product: .framework,
                bundleId: bundleId,
                deploymentTarget: deploymentTarget,
                infoPlist: .file(path: "AudioPlayer/Info.plist"),
                sources: [
                    "AudioPlayer/Sources/**"
                ]
            )

        }
    }
}

enum AzkarPackage: String {
    case entities = "Entities"
    case databaseClient = "DatabaseClient"

    var name: String { rawValue }

    var path: Path {
        return "Packages/\(name)"
    }
}

let packages: [Package] = [
    .remote(url: "https://github.com/SimonFairbairn/SwiftyMarkdown", requirement: .upToNextMajor(from: "1.2.3")),
    .remote(url: "https://github.com/bizz84/SwiftyStoreKit", requirement: .upToNextMajor(from: "0.16.3")),
    .remote(url: "https://github.com/malcommac/SwiftRichString", requirement: .upToNextMajor(from: "3.7.2")),
    .remote(url: "https://github.com/radianttap/Coordinator", requirement: .upToNextMajor(from: "6.4.2")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from: "3.0.0")),
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
            testAction: TestAction.testPlans("Azkar/Resources/quiz.xctestplan"),
            runAction: RunAction(executable: "Azkar")
        )
    ],
    additionalFiles: []
)
