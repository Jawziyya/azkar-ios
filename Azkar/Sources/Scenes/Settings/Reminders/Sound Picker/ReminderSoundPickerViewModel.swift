// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import UserNotifications
import AudioPlayer

enum ReminderSound: String, Identifiable, Equatable, Codable {
    
    case standard, glass, bamboo, note
    case forSure, beyondDoubt, purr, twitter, pristine, deduction, timeIsNow
    
    static var standardSounds: [ReminderSound] {
        [standard, glass, bamboo, note]
    }
    
    static var customSounds: [ReminderSound] {
        [forSure, beyondDoubt, purr, twitter, pristine, deduction, timeIsNow]
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .standard:
            return L10n.Common.default
        case .forSure:
            return "For Sure"
        case .beyondDoubt:
            return "Beyond Doubt"
        case .timeIsNow:
            return "Time is now"
        default:
            return rawValue.capitalized
        }
    }
    
    var fileName: String { rawValue }
    
    var soundFileFormat: String {
        switch self {
        case .standard, .glass, .bamboo, .note, .purr, .twitter:
            return "m4a"
        case .forSure, .beyondDoubt, .pristine, .deduction, .timeIsNow:
            return "m4r"
        }
    }
    
    var link: URL? {
        switch self {
        case .pristine:
            return URL(string: "https://notificationsounds.com/message-tones/pristine-609")
            
        case .deduction:
            return URL(string: "https://notificationsounds.com/notification-sounds/deduction-588")
            
            
        case .timeIsNow:
            return URL(string: "https://notificationsounds.com/notification-sounds/time-is-now-585")
            
        default:
            return nil
        }
    }
    
}

extension ReminderSound {
    
    var notificationSound: UNNotificationSound {
        return UNNotificationSound.default
    }
    
}

final class ReminderSoundPickerViewModel: ObservableObject {
    
    enum Section: String, Equatable, Identifiable, CaseIterable {
        case standard, custom
        
        var title: String {
            return rawValue
        }
        
        var id: String { rawValue }
        
        var sounds: [ReminderSound] {
            switch self {
            case .standard: return ReminderSound.standardSounds
            case .custom: return ReminderSound.customSounds
            }
        }
    }
    
    let sections = [Section.standard, Section.custom]
    
    init(preferredSound: ReminderSound) {
        self.preferredSound = preferredSound
    }
    
    private let player = AudioPlayer()
    
    @Published var preferredSound: ReminderSound
    
    static var placeholder: ReminderSoundPickerViewModel {
        return ReminderSoundPickerViewModel(preferredSound: ReminderSound.standard)
    }
    
    func playSound(_ sound: ReminderSound) {
        guard
            let url = Bundle.main.url(forResource: sound.fileName, withExtension: sound.soundFileFormat),
            let audioItem = AudioItem(soundURLs: [.high: url]) else {
            return
        }
        player.pause()
        player.play(item: audioItem)
    }
    
    func setPreferredSound(_ sound: ReminderSound) {
        self.preferredSound = sound
    }
    
    func isSoundAvailable(_ sound: ReminderSound) -> Bool {
        return true
    }
    
}
