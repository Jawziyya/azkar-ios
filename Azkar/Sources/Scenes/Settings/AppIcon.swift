//
//  AppIcon.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum AppIconPack: String, CaseIterable, Identifiable, Codable {
    case standard, maccinz, darsigova

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
        case .darsigova:
            return URL(string: "https://instagram.com/art.darsigova")!
        }
    }

    var icons: [AppIcon] {
        switch self {
        case .standard:
            return AppIcon.standardIcons
        case .maccinz:
            return AppIcon.maccinzIcons
        case .darsigova:
            return AppIcon.darsigovaIcons
        }
    }

}

enum AppIcon: String, Codable, CaseIterable, Identifiable {

    case gold, ink, darkNight = "dark_night"
    case midjourney001

    static var standardIcons: [AppIcon] {
        [gold, ink, darkNight, midjourney001]
    }

    case maccinz_house, maccinz_mountains, maccinz_ramadan_night, maccinz_day

    case darsigova_1, darsigova_2, darsigova_3, darsigova_4, darsigova_5, darsigova_6, darsigova_7, darsigova_8, darsigova_9, darsigova_10

    static var maccinzIcons: [AppIcon] {
        [maccinz_house, maccinz_mountains, maccinz_ramadan_night, maccinz_day]
    }

    static var darsigovaIcons: [AppIcon] {
        [darsigova_1, darsigova_2, darsigova_3, darsigova_4, darsigova_5, darsigova_6, darsigova_7, darsigova_8, darsigova_9, darsigova_10]
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
