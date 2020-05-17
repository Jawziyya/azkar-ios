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

    init(zikrViewModel: ZikrViewModel, preferences: Preferences) {
        let hadith = Hadith.data.first(where: { $0.id == zikrViewModel.zikr.hadith })!
        self.init(hadith: hadith, preferences: preferences)
    }

    init(hadith: Hadith, preferences: Preferences) {
        self.preferences = preferences
        self.hadith = hadith
        text = hadith.text
        translation = hadith.translation
        source = "\(hadith.source), \(hadith.number)"
    }

}
