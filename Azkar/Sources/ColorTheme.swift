// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Library

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
        case .reader:
            return L10n.Settings.Theme.ColorTheme.reader
        case .flat:
            return "Flat"
        case .reader:
            return "Reader"
        case .neomorphic:
            return "Neomorphic"
        }
    }

}
