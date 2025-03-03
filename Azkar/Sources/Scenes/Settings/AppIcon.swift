//
//  AppIcon.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum AppIconPack: String, CaseIterable, Identifiable, Codable {
    case standard

    var productIdentifier: String {
        return Bundle.main.bundleIdentifier!.replacingOccurrences(of: "-", with: "_") + ".\(rawValue)_icon_pack"
    }

    var id: String {
        rawValue
    }

    var title: String {
        return NSLocalizedString("icon_pack.\(rawValue).title", comment: "Icon pack name.")
    }

    var description: String {
        return NSLocalizedString("icon_pack.\(rawValue).description", comment: "Icon pack description.")
    }

    var link: URL? {
        switch self {
        case .standard:
            return nil
        }
    }

    var icons: [AppIcon] {
        switch self {
        case .standard:
            return AppIcon.standardIcons
        }
    }

}

enum AppIcon: String, Codable, CaseIterable, Identifiable {

    case gold, ink, darkNight = "dark_night"
    case midjourney001

    static var standardIcons: [AppIcon] {
        [gold, ink, darkNight, midjourney001]
    }

    var id: String { rawValue }

    var title: String {
        switch self {
        case .midjourney001:
            return "MidJourney x Azkar 0.0.1"
        default:
            return NSLocalizedString("settings.icon.list.\(rawValue)", comment: "")
        }
    }

    var referenceName: String {
        rawValue
    }

    var imageName: String {
        switch self {
        case .gold: return "AppIcon"
        default: return rawValue
        }
    }

}
