//
//  AppIcon.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum AppIconPack: String, CaseIterable, Identifiable, Codable {
    case standard, maccinz

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
        case .maccinz:
            return URL(string: "https://dribbble.com/maccinz")!
        }
    }

    var icons: [AppIcon] {
        switch self {
        case .standard:
            return AppIcon.standardIcons
        case .maccinz:
            return AppIcon.maccinzIcons
        }
    }

}

enum AppIcon: String, Codable, CaseIterable, Identifiable {

    case gold, ink, darkNight = "dark_night"

    static var standardIcons: [AppIcon] {
        [gold, ink, darkNight]
    }

    case maccinz_house, maccinz_mountains, maccinz_ramadan_night, maccinz_day, maccinz_confetti, maccinz_confetti_dark

    static var maccinzIcons: [AppIcon] {
        [maccinz_house, maccinz_mountains, maccinz_ramadan_night, maccinz_day]
    }

    var id: String { rawValue }

    var title: String {
        return NSLocalizedString("settings.icon.list.\(rawValue)", comment: "")
    }

    var referenceName: String {
        rawValue
    }

    var imageName: String {
        "ic_\(referenceName).png"
    }

}
