//
//  ZikrViewModel.swift
//  Azkar
//
//  Created by Al Jawziyya on 07.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine
import UIKit

final class ZikrViewModel: ObservableObject, Identifiable, Equatable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(zikr)
    }

    static func == (lhs: ZikrViewModel, rhs: ZikrViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String {
        title
    }

    let zikr: Zikr
    let title: String
    var text: String {
        preferences.showTashkeel ? zikr.text : zikr.text.trimmingArabicVowels
    }
    let preferences: Preferences

    let showTransliteration: Bool
    let showTranslation: Bool

    var playerViewModel: PlayerViewModel?
    var hadithViewModel: HadithViewModel?

    @Published var expandTranslation: Bool
    @Published var expandTransliteration: Bool

    private var cancellabels: [AnyCancellable] = []

    init(zikr: Zikr, preferences: Preferences, player: Player) {
        self.zikr = zikr
        self.preferences = preferences
        title = zikr.title ?? "\(NSLocalizedString("common.zikr", comment: "")) №\(zikr.rowInCategory)"
        
        let isUsingArabicLanguage = Locale.preferredLanguages[0].lowercased().contains("ar")
        
        showTransliteration = !isUsingArabicLanguage
        showTranslation = !isUsingArabicLanguage

        expandTranslation = preferences.expandTranslation
        expandTransliteration = preferences.expandTransliteration

        if let url = zikr.audioURL {
            playerViewModel = PlayerViewModel(title: title, subtitle: zikr.category.title, audioURL: url, player: player)
        }

        #if SHOW_AZKAR_SOURCES
        if zikr.hadith != nil {
            hadithViewModel = HadithViewModel(zikrViewModel: self, preferences: preferences)
        }
        #endif

        cancellabels = [
            preferences.$expandTranslation.assign(to: \.expandTranslation, on: self),
            preferences.$expandTransliteration.assign(to: \.expandTransliteration, on: self)
        ]
    }

}
