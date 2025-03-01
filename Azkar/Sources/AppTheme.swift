// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Library

extension ColorTheme: PickableItem {
    var title: String {
        switch self {
        case .sea:
            return L10n.Settings.Appearance.ColorTheme.sea
        case .purpleRose:
            return L10n.Settings.Appearance.ColorTheme.purpleRose
        case .ink:
            return L10n.Settings.Appearance.ColorTheme.ink
        case .roseQuartz:
            return L10n.Settings.Appearance.ColorTheme.roseQuartz
        case .forest:
            return L10n.Settings.Appearance.ColorTheme.forest
        case .default:
            return L10n.Common.default
        }
    }
}

extension AppTheme: PickableItem {
    
    var title: String {
        switch self {
        case .reader:
            return L10n.Settings.Appearance.AppTheme.reader
        case .code:
            return "c0de"
        case .flat:
            return L10n.Settings.Appearance.AppTheme.flat
        case .neomorphic:
            return "Neomorphic"
        case .default:
            return L10n.Common.default
        }
    }

}
