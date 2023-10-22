// Copyright © 2023 Azkar
// All Rights Reserved.

import UIKit

final class AppearanceViewModel: SettingsSectionViewModel {
    
    var canChangeIcon: Bool {
        return !UIDevice.current.isMac
    }
    
    var themeTitle: String {
        "\(preferences.theme.title), \(preferences.colorTheme.title)"
    }
    
    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }
    
    var colorSchemeViewModel: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: preferences) { [unowned router] in
            router.trigger(.subscribe)
        }
    }
    
}
