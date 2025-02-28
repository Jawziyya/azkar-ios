// Copyright © 2023 Azkar
// All Rights Reserved.

import UIKit
import AzkarServices

final class AppearanceViewModel: SettingsSectionViewModel {
    
    var canChangeIcon: Bool {
        return !UIDevice.current.isMac
    }
    
    var themeTitle: String {
        "\(preferences.appTheme.title), \(preferences.colorTheme.title)"
    }
    
    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }
    
    var colorSchemeViewModel: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: preferences) { [unowned router] in
            router.trigger(.subscribe(sourceScreen: ColorSchemesView.viewName))
        }
    }
    
}
