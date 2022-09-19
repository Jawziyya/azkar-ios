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
import AudioPlayer

final class ZikrViewModel: ObservableObject, Identifiable, Equatable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(zikr)
    }

    static func == (lhs: ZikrViewModel, rhs: ZikrViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    var id: Int {
        zikr.id
    }

    let zikr: Zikr
    let title: String

    @Published private(set) var text: [String]
    @Published private(set) var translation: [String]
    @Published private(set) var transliteration: [String]

    @Published private(set) var highlightCurrentIndex = true
    @Published private(set) var indexToHighlight: Int?

    let preferences: Preferences
    let counter: ZikrCounterServiceType
    let textProcessor: TextProcessor

    let source: String

    var playerViewModel: PlayerViewModel?
    var hadithViewModel: HadithViewModel?

    @Published var expandTranslation: Bool

    let hasTransliteration: Bool
    @Published var expandTransliteration: Bool
    
    @Published var textSettingsToken = UUID()

    @Published var remainingRepeatsFormatted: String = ""
    @Published var remainingRepeatsNumber: Int {
        didSet {
            updateRemainingRepeatsText()
        }
    }
    private var showRemainingCounter = true {
        didSet {
            updateRemainingRepeatsText()
        }
    }

    func updateRemainingRepeats() {
        remainingRepeatsNumber = counter.getRemainingRepeats(for: zikr)
    }

    func updateRemainingRepeatsText() {
        if !showRemainingCounter || remainingRepeatsNumber == zikr.repeats {
            remainingRepeatsFormatted = L10n.repeats(zikr.repeats)
        } else {
            remainingRepeatsFormatted = L10n.remainingRepeats(remainingRepeatsNumber)
        }
    }

    private var cancellables: Set<AnyCancellable> = []
    private lazy var player = AudioPlayer()

    init(
        zikr: Zikr,
        hadith: Hadith?,
        preferences: Preferences,
        player: Player,
        counter: ZikrCounterServiceType = ZikrCounterService(),
        textProcessor: TextProcessor = TextProcessor(preferences: Preferences.shared)
    ) {
        self.counter = counter
        self.zikr = zikr
        self.preferences = preferences
        self.remainingRepeatsNumber = counter.getRemainingRepeats(for: zikr)
        self.textProcessor = textProcessor
        title = zikr.title ?? "\(L10n.Common.zikr) №\(zikr.rowInCategory)"
        text = textProcessor.processArabicText(zikr.text)
        
        expandTranslation = preferences.expandTranslation
        expandTransliteration = preferences.expandTransliteration
        hasTransliteration = zikr.transliteration?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        
        translation = zikr.translation?.textOrNil.flatMap(textProcessor.processTranslationText) ?? []
        transliteration = zikr.transliteration?.textOrNil.flatMap(textProcessor.processTransliterationText) ?? []
        source = zikr.source

        if let url = zikr.audioURL {
            let playerViewModel = PlayerViewModel(title: title, subtitle: zikr.category.title, audioURL: url, player: player)
            self.playerViewModel = playerViewModel

            do {
                let timings = try DatabaseService.shared.getAudioTimings(audioId: zikr.audioId ?? -1)
                playerViewModel
                    .$progressInSeconds
                    .filter { $0 > 0 }
                    .compactMap { time -> AudioTiming? in
                        return timings.last(where: { $0.time == time || $0.time < time })
                    }
                    .removeDuplicates()
                    .sink { [weak self] timing in
                        self?.indexToHighlight = timings.firstIndex(of: timing) ?? 0
                    }
                    .store(in: &cancellables)

                playerViewModel
                    .$progress
                    .sink { [weak self] progress in
                        if progress == 0 {
                            self?.indexToHighlight = nil
                        }
                    }
                    .store(in: &cancellables)
            } catch {
                print(error.localizedDescription)
            }
        }

        if let hadith = hadith {
            hadithViewModel = HadithViewModel(hadith: hadith, preferences: preferences)
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

        preferences.$enableLineBreaks
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [unowned self] _ in
                text = textProcessor.processArabicText(zikr.text)
                translation = zikr.translation?.textOrNil.flatMap(textProcessor.processTranslationText) ?? []
                transliteration = zikr.transliteration?.textOrNil.flatMap(textProcessor.processTransliterationText) ?? []
            })
            .store(in: &cancellables)

        updateRemainingRepeatsText()
    }
    
    func getShareText(
        includeTitle: Bool,
        includeTranslation: Bool,
        includeTransliteration: Bool,
        includeBenefits: Bool
    ) -> String {
        var text = ""
        
        if includeTitle, let title = zikr.title {
            text += title
        }
        
        text += "\n\n\(zikr.text)"
        
        if includeTranslation, !translation.isEmpty {
            text += "\n\n\(translation.joined(separator: "\n"))"
        }
        
        if includeTransliteration, !transliteration.isEmpty {
            text += "\n\n\(transliteration.joined(separator: "\n"))"
        }
        
        text += "\n\n\(zikr.source)"
        
        if includeBenefits, let benefit = zikr.benefit {
            text += "\n\n[\(benefit)]"
        }
        
        return text
    }
    
    func increaseFontSize() {
        preferences.sizeCategory = preferences.sizeCategory.bigger()
    }
    
    func decreaseFontSize() {
        preferences.sizeCategory = preferences.sizeCategory.smaller()
    }

    func incrementZikrCount() {
        guard remainingRepeatsNumber > 0 else {
            return
        }
        showRemainingCounter = true
        counter.incrementCounter(for: zikr)
        remainingRepeatsNumber = counter.getRemainingRepeats(for: zikr)

        guard preferences.enableCounterTicker else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            self.playTickerSound()
        }
    }

    func toggleCounterFormat() {
        showRemainingCounter.toggle()
    }

    private func playTickerSound() {
        guard
            let url = Bundle.main.url(forResource: "counter-ticker", withExtension: "m4a"),
            let audioItem = AudioItem(soundURLs: [.high: url]) else {
            return
        }
        player.volume = 0.25
        player.pause()
        player.play(item: audioItem)
    }

}
