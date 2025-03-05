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
            return L10n.Settings.Appearance.ColorScheme.Auto.title
        case .light:
            return L10n.Settings.Appearance.ColorScheme.Light.title
        case .dark:
            return L10n.Settings.Appearance.ColorScheme.Dark.title
        }
    }
    
    var description: String {
        switch self {
        case .automatic:
            return L10n.Settings.Appearance.ColorScheme.Auto.description
        case .light:
            return L10n.Settings.Appearance.ColorScheme.Light.description
        case .dark:
            return L10n.Settings.Appearance.ColorScheme.Dark.description
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
