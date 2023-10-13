// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Extensions

public struct TextProcessor {

    private let preferences: TextProcessingPreferences

    public init(preferences: TextProcessingPreferences) {
        self.preferences = preferences
    }

    public func processArabicText(_ text: String) -> [String] {
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

    public func processTranslationText(_ text: String) -> [String] {
        let t = text

        if preferences.enableLineBreaks {
            return t.components(separatedBy: "\n")
        } else {
            return [t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)]
        }
    }

    public func processTransliterationText(_ text: String) -> [String] {
        let t = text

        if preferences.enableLineBreaks {
            return t.components(separatedBy: "\n")
        } else {
            return [t.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)]
        }
    }

}
