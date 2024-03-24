// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import Library

final class TextSettingsViewModel: SettingsSectionViewModel {
    
    var readingModeSampleZikr: Zikr? {
        try? databaseService.getZikr(2, language: preferences.contentLanguage)
    }
    
    var databaseService: AzkarDatabase {
        AzkarDatabase(language: preferences.contentLanguage)
    }
    
    var canChangeLanguage: Bool {
        return true
    }
    
    var selectedArabicFontSupportsVowels: Bool {
        return preferences.preferredArabicFont.hasTashkeelSupport
    }
        
    func getAvailableLanguages() -> [Language] {
        return Language.allCases.filter(databaseService.translationExists(for:))
    }
    
    func getFontsViewModel(fontsType: FontsType) -> FontsViewModel {
        FontsViewModel(fontsType: fontsType, service: FontsService(), subscribeScreenTrigger: { [unowned self] in
            self.router.trigger(.subscribe)
        })
    }
    
}
