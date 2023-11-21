// Copyright © 2023 Azkar
// All Rights Reserved.

import UIKit
import WhatsNewKit
import SwiftUI

func getVersionStore() -> WhatsNewVersionStore {
    if CommandLine.arguments.contains("ALWAYS_SHOW_CHANGELOG") {
        InMemoryWhatsNewVersionStore()
    } else {
        UserDefaultsWhatsNewVersionStore()
    }
}

func getWhatsNew() -> WhatsNew? {
    let versionStore = getVersionStore()
    let currentAppVersion = WhatsNew.Version.current()
    let changelogs: [Changelog]
    
    do {
        guard let url = Bundle.main.url(forResource: "Changelog", withExtension: "json") else {
            return nil
        }
        
        let file = try Data(contentsOf: url)
        changelogs = try JSONDecoder().decode([Changelog].self, from: file)
    } catch {
        return nil
    }
    
    // Comparing current app version against version in Changelog.json file
    // If the major and minor versions do not match, we'll not display changelog to the user.
    guard let changelog = changelogs.first(where: { changelog in
        changelog.versionInfo.major == currentAppVersion.major && 
        changelog.versionInfo.minor == currentAppVersion.minor
    }) else {
        return nil
    }
    
    guard versionStore.hasPresented(currentAppVersion) == false else {
        return nil
    }
    
    return changelog.whatsNew
}

func getWhatsNewView(_ whatsNew: WhatsNew) -> WhatsNewView {
    WhatsNewView(
        whatsNew: whatsNew,
        versionStore: getVersionStore()
    )
}

func getWhatsNewViewController(_ whatsNew: WhatsNew) -> UIViewController? {
    guard let viewController = WhatsNewViewController(
        whatsNew: whatsNew,
        versionStore: getVersionStore()
    ) else {
        return nil
    }
    return viewController
}

struct Changelog: Decodable {
    
    struct FeatureImage: Decodable {
        enum ImageType: String, Decodable {
            case symbol, bundled
        }
        
        enum ImageRenderingMode: String, Decodable {
            case original, template
        }
        
        let type: ImageType
        let name: String
        let color: String?
        let renderingMode: ImageRenderingMode?
        
        private var _color: Color {
            if let color {
                return Color(hex: color)
            } else {
                return [
                    UIColor.systemRed,
                    UIColor.systemGreen,
                    UIColor.systemBlue,
                    UIColor.systemOrange,
                    UIColor.systemIndigo,
                    UIColor.systemPurple,
                    UIColor.systemTeal,
                    UIColor.systemBrown,
                    UIColor.systemCyan,
                    UIColor.systemMint,
                    UIColor.systemPink,
                ]
                .map(Color.init(uiColor:))
                .randomElement()!
            }
        }
        
        var featureImage: WhatsNew.Feature.Image {
            switch type {
            case .bundled:
                return .init(
                    name: name,
                    bundle: Bundle.main,
                    renderingMode: renderingMode == .original ? .original : .template,
                    foregroundColor: _color
                )
            case .symbol:
                return .init(
                    systemName: name,
                    renderingMode: renderingMode == .original ? .original : .template,
                    foregroundColor: _color
                )
            }
        }
    }
    
    struct Feature: Decodable {
        let title: String
        let subtitle: String
        let image: FeatureImage

        var whatsNewItem: WhatsNew.Feature {
            return WhatsNew.Feature(
                image: image.featureImage,
                title: .init(title),
                subtitle: .init(subtitle)
            )
        }
    }
    
    let version: String
    let title: String?
    let continueTitle: String?
    let items: [Feature]
    
    var versionInfo: WhatsNew.Version {
        .init(stringLiteral: version)
    }
    
    var whatsNew: WhatsNew {
        WhatsNew(
            version: versionInfo,
            title: .init(stringLiteral: title ?? L10n.Updates.title),
            features: items.map(\.whatsNewItem),
            primaryAction: WhatsNew.PrimaryAction(
                title: .init(continueTitle ?? L10n.Common.continue),
                backgroundColor: Color.accent,
                foregroundColor: Color.white,
                hapticFeedback: WhatsNew.HapticFeedback.selection,
                onDismiss: nil
            )
        )
    }
}
