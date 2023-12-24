//
//  HadithViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation

struct HadithViewModel {

    private let hadith: Hadith

    let preferences: Preferences

    let text: String
    let translation: String?
    let source: String
    let highlightPattern: String?

    init(hadith: Hadith, highlightPattern: String?, preferences: Preferences) {
        self.preferences = preferences
        self.highlightPattern = highlightPattern
        self.hadith = hadith
        text = (preferences.showTashkeel && preferences.preferredArabicFont.hasTashkeelSupport ? hadith.text : hadith.text.trimmingArabicVowels).trimmingCharacters(in: .whitespacesAndNewlines)
        translation = hadith.translation?.trimmingCharacters(in: .whitespacesAndNewlines)
        source = hadith.source
    }

}
