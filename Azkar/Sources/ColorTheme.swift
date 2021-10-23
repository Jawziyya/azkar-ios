// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

private let preferences = Preferences()

var colorTheme: ColorTheme {
    preferences.colorTheme
}

enum ColorTheme: String, CaseIterable, Equatable, Codable {
    case `default`, sea, purpleRose, ink, roseQuartz
    
    var colorsNamespacePrefix: String {
        switch self {
        case .default: return ""
        case .sea: return "Sea/"
        case .purpleRose: return "PurpleRose/"
        case .ink: return "Ink/"
        case .roseQuartz: return "RoseQuartz/"
        }
    }
}

extension ColorTheme: PickableItem {
    
    var title: String {
        switch self {
        case .default:
            return L10n.Common.default
        case .sea:
            return L10n.Settings.Theme.ColorTheme.sea
        case .purpleRose:
            return L10n.Settings.Theme.ColorTheme.purpleRose
        case .ink:
            return L10n.Settings.Theme.ColorTheme.ink
        case .roseQuartz:
            return L10n.Settings.Theme.ColorTheme.roseQuartz
        }
    }
    
    var image: Image? {
        switch self {
        case .default:
            return nil
        case .sea:
            return nil
        case .purpleRose:
            return nil
        case .ink:
            return nil
        case .roseQuartz:
            return nil
        }
    }
    
}
