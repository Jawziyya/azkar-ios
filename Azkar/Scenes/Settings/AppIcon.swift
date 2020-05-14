//
//  AppIcon.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum AppIcon: String, Codable, CaseIterable, Hashable, PickableItem, Identifiable {
    case light, ink, dark, ramadan = "purple"

    static var availableIcons: [AppIcon] {
        return Array(allCases.prefix(3))
    }

    var iconName: String? {
        switch self {
        case .light:
            return nil
        default:
            return rawValue
        }
    }

    var title: String {
        switch self {
        case .light:
            return "Золото"
        case .ink:
            return "Чернила"
        case .dark:
            return "Тёмная ночь"
        case .ramadan:
            return "Рамадан"
        }
    }

    var id: String {
        rawValue
    }

    var image: Image? {
        Image(uiImage: UIImage(named: "ic_\(rawValue).png")!)
    }
}
