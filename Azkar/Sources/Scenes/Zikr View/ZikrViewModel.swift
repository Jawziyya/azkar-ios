//
//  ZikrViewModel.swift
//  Azkar
//
//  Created by Al Jawziyya on 07.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI
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
        preferences.showTashkeel && preferences.preferredArabicFont.hasTashkeelSupport ? zikr.text : zikr.text.trimmingArabicVowels
    }
    let preferences: Preferences

    let transliteration: String?
    let translation: String?
    let source: String

    var playerViewModel: PlayerViewModel?
    var hadithViewModel: HadithViewModel?

    @Published var expandTranslation: Bool

    let hasTransliteration: Bool
    @Published var expandTransliteration: Bool
    
    @Published var textSettingsToken = UUID()

    private var cancellables: Set<AnyCancellable> = []

    init(zikr: Zikr, preferences: Preferences, player: Player) {
        self.zikr = zikr
        self.preferences = preferences
        title = zikr.title ?? "\(L10n.Common.zikr) №\(zikr.rowInCategory)"
        
        expandTranslation = preferences.expandTranslation
        expandTransliteration = preferences.expandTransliteration
        hasTransliteration = zikr.transliteration?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        
        transliteration = zikr.transliteration?.textOrNil
        translation = zikr.translation?.textOrNil
        source = zikr.source

        if let url = zikr.audioURL {
            playerViewModel = PlayerViewModel(title: title, subtitle: zikr.category.title, audioURL: url, player: player)
        }

        if zikr.hadith != nil {
            hadithViewModel = HadithViewModel(zikrViewModel: self, preferences: preferences)
        }
        
        cancellables.insert(
            preferences.$expandTranslation.assign(to: \.expandTranslation, on: self)
        )

        cancellables.insert(
            preferences.$expandTransliteration.assign(to: \.expandTransliteration, on: self)
        )
        
        preferences.fontSettingsChangesPublisher()
            .receive(on: RunLoop.main)
            .sink { [unowned self] id in
                self.textSettingsToken = id
            }
            .store(in: &cancellables)
    }

}
