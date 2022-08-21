// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation

struct TextProcessor {

    private let preferences: Preferences

    init(preferences: Preferences) {
        self.preferences = preferences
    }

    func processArabicText(_ text: String) -> String {
        var t = text

        if preferences.enableLineBreaks == false {
            t = t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        }

        if !preferences.showTashkeel || !preferences.preferredArabicFont.hasTashkeelSupport {
            t = t.trimmingArabicVowels
        }

        return t
    }

    func processTranslationText(_ text: String) -> String {
        var t = text

        if preferences.enableLineBreaks == false {
            t = t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        }

        return t
    }

    func processTransliterationText(_ text: String) -> String {
        var t = text

        if preferences.enableLineBreaks == false {
            t = t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        }

        return t
    }

}
