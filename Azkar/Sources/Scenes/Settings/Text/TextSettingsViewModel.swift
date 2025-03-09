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
    
    var availableTransliterationTypes: [ZikrTransliterationType] {
        switch preferences.contentLanguage {
        case .arabic, .english, .georgian, .turkish: return [.community, .DIN31635]
        case .russian, .chechen, .ingush, .kazakh, .kyrgyz, .uzbek: return [.community, .ruScientific, .DIN31635]
        }
    }
    
    var selectedArabicFontSupportsVowels: Bool {
        return preferences.preferredArabicFont.hasTashkeelSupport
    }
    
    func getAvailableLanguages() -> [Language] {
        return Language.allCases.filter(databaseService.translationExists(for:))
    }
    
    func getFontsViewModel(fontsType: FontsType) -> FontsViewModel {
        let sampleText: String
        let sampleZikr = try? databaseService.getZikr(29, language: preferences.contentLanguage)
        switch fontsType {
        case .arabic:
            sampleText = (sampleZikr?.text ?? "بِسۡمِ ٱللَّهِ‎").trimmingArabicVowels
            
        case .translation:
            sampleText = sampleZikr?.translation ?? "bismillah"
            
        }
        
        return FontsViewModel(
            sampleText: sampleText,
            fontsType: fontsType,
            service: FontsService(),
            subscribeScreenTrigger: { [unowned self] in
                self.router.trigger(.subscribe(sourceScreen: FontsView.viewName))
            }
        )
    }
    
    func setContentLanguage(_ language: Language) {
        preferences.contentLanguage = language
        if availableTransliterationTypes.contains(preferences.transliterationType) == false {
            preferences.transliterationType = .community
        }
    }
    
}
