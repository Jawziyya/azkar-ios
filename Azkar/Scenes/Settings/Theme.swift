//
//  Theme.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum Theme: Int, Codable, CaseIterable, Identifiable, PickableItem, Hashable {
    case automatic, light, dark

    var id: Int {
        return rawValue
    }

    var title: String {
        switch self {
        case .automatic:
            return NSLocalizedString("settings.theme.auto", comment: "")
        case .light:
            return NSLocalizedString("settings.theme.light", comment: "")
        case .dark:
            return NSLocalizedString("settings.theme.dark", comment: "")
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }

    var statusBarStyle: UIStatusBarStyle? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        }
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

}
