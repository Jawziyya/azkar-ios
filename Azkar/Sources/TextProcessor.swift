// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation

struct TextProcessor {

    private let preferences: Preferences

    init(preferences: Preferences) {
        self.preferences = preferences
    }

    func processArabicText(_ text: String) -> [String] {
        var t = text

        if !preferences.showTashkeel || !preferences.preferredArabicFont.hasTashkeelSupport {
            t = t.trimmingArabicVowels
        }

        if preferences.enableLineBreaks {
            return t.components(separatedBy: "\n")
        } else {
            return [t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)]
        }
    }

    func processTranslationText(_ text: String) -> [String] {
        let t = text

        if preferences.enableLineBreaks {
            return t.components(separatedBy: "\n")
        } else {
            return [t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)]
        }
    }

    func processTransliterationText(_ text: String) -> [String] {
        let t = text

        if preferences.enableLineBreaks {
            return t.components(separatedBy: "\n")
        } else {
            return [t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)]
        }
    }

}
