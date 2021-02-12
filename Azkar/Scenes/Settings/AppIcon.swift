//
//  AppIcon.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum AppIcon: String, Codable, CaseIterable, Hashable, PickableItem, Identifiable {
    case gold, ink, darkNight = "dark_night", ramadan

    static var availableIcons: [AppIcon] {
        return allCases
    }

    var title: String {
        return NSLocalizedString("settings.icon.list.\(id)", comment: "")
    }

    var id: String {
        rawValue
    }

    var image: Image? {
        Image(uiImage: UIImage(named: "ic_\(id).png")!)
    }
}
