import UIKit
import SwiftUI
import Combine
import AudioPlayer
import AVFoundation
import Library

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
    /// Is nested into a container like page view or other.
    let isNested: Bool

    @Published private(set) var text: [String]
    @Published private(set) var translation: [String]
    @Published private(set) var transliteration: [String]
    let highlightPattern: String?

    @Published private(set) var highlightCurrentIndex = true
    @Published private(set) var indexToHighlight: Int?

    let preferences: Preferences
    let counter: ZikrCounterType
    let textProcessor: TextProcessor

    let source: String

    var playerViewModel: PlayerViewModel?
    var hadithViewModel: HadithViewModel?

    @Published var expandTranslation: Bool

    let hasTransliteration: Bool
    @Published var expandTransliteration: Bool
    
    @Published var textSettingsToken = UUID()

    @Published var remainingRepeatsFormatted: String = ""
    @Published var remainingRepeatsNumber: Int = 0 {
        didSet {
            updateRemainingRepeatsText()
        }
    }
    private var showRemainingCounter = true {
        didSet {
            updateRemainingRepeatsText()
        }
    }

    @MainActor
    func updateRemainingRepeats() async {
        remainingRepeatsNumber = await counter.getRemainingRepeats(for: zikr)
    }

    func updateRemainingRepeatsText() {
        if !showRemainingCounter || remainingRepeatsNumber == zikr.repeats {
            remainingRepeatsFormatted = L10n.repeatsNumber(zikr.repeats)
        } else {
            remainingRepeatsFormatted = L10n.remainingRepeats(remainingRepeatsNumber)
        }
    }

    private var cancellables: Set<AnyCancellable> = []
    private let player: Player
    
    public var audioURL: URL? {
        if let link = zikr.audio?.link {
            return Bundle.main.url(forAuxiliaryExecutable: link)
        }
        return nil
    }
    
    public var audioDuration: Double? {
        guard let url = audioURL else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        return Double(CMTimeGetSeconds(asset.duration))
    }

    init(
        zikr: Zikr,
        isNested: Bool,
        highlightPattern: String? = nil,
        row: Int? = nil,
        hadith: Hadith?,
        preferences: Preferences,
        player: Player,
        counter: ZikrCounterType = ZikrCounter.shared,
        textProcessor: TextProcessor = TextProcessor(preferences: Preferences.shared)
    ) {
        self.highlightPattern = highlightPattern
        self.counter = counter
        self.isNested = isNested
        self.zikr = zikr
        self.preferences = preferences
        self.textProcessor = textProcessor
        self.player = player
        
        if let zikrTitle = zikr.title {
            title = zikrTitle
        } else if let row {
            title = "\(L10n.Common.zikr) №\(row)"
        } else {
            title = L10n.Common.zikr
        }
        
        text = textProcessor.processArabicText(zikr.text)
        
        expandTranslation = preferences.expandTranslation
        expandTransliteration = preferences.expandTransliteration
        hasTransliteration = zikr.transliteration?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        
        translation = zikr.translation?.textOrNil.flatMap(textProcessor.processTranslationText) ?? []
        transliteration = zikr.transliteration?.textOrNil.flatMap(textProcessor.processTransliterationText) ?? []
        source = zikr.source.firstWord()
        
        Task {
            self.remainingRepeatsNumber = await counter.getRemainingRepeats(for: zikr)
        }

        if let url = audioURL {
            let timings = zikr.audioTimings
            let playerViewModel = PlayerViewModel(
                title: title,
                subtitle: zikr.category?.title,
                audioURL: url,
                timings: timings,
                player: player
            )
            self.playerViewModel = playerViewModel

            playerViewModel
                .$progressInSeconds
                .filter { _ in preferences.enableLineBreaks }
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
        }

        if let hadith = hadith {
            hadithViewModel = HadithViewModel(
                hadith: hadith,
                highlightPattern: highlightPattern,
                preferences: preferences
            )
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
        ShareTextProvider(
            zikr: zikr,
            translation: translation,
            transliteration: transliteration,
            includeTitle: includeTitle,
            includeTranslation: includeTranslation,
            includeTransliteration: includeTransliteration,
            includeBenefits: includeBenefits
        )
        .getShareText()
    }
    
    func increaseFontSize() {
        preferences.sizeCategory = preferences.sizeCategory.bigger()
    }
    
    func decreaseFontSize() {
        preferences.sizeCategory = preferences.sizeCategory.smaller()
    }

    @MainActor
    func incrementZikrCount() async {
        guard remainingRepeatsNumber > 0 else {
            return
        }
        showRemainingCounter = true
        do {
            try await counter.incrementCounter(for: zikr)
        } catch {
            return
        }
        let remainingRepeatsNumber = await counter.getRemainingRepeats(for: zikr)
        
        withAnimation(.spring()) {
            self.remainingRepeatsNumber = remainingRepeatsNumber
        }

        if preferences.enableCounterTicker, !player.isPlaying {
            DispatchQueue.global(qos: .userInitiated).async {
                self.playTickerSound()
            }
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
        player.playItem(audioItem, atVolume: 0.25)
    }
    
    func playAudio(at index: Int) {
        if text.count > 1 {
            indexToHighlight = index
        }
        playerViewModel?.goToTiming(at: index)
    }
    
    func pausePlayer() {
        player.pause()
    }

}
