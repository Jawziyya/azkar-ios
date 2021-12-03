// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import UserNotifications
import AudioPlayer

enum ReminderSound: String, Identifiable, Equatable, Codable {
    
    case standard, glass, bamboo, note
    case forSure, beyondDoubt, alert
    
    static var standardSounds: [ReminderSound] {
        [standard, glass, bamboo, note]
    }
    
    static var customSounds: [ReminderSound] {
        [forSure, beyondDoubt, alert]
    }
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .standard:
            return L10n.Common.default
        case .glass:
            return "Glass"
        case .bamboo:
            return "Bamboo"
        case .note:
            return "Note"
        case .forSure:
            return "For Sure"
        case .beyondDoubt:
            return "Beyond Doubt"
        case .alert:
            return "Alert"
        }
    }
    
    var soundName: String {
        switch self {
        case .standard:
            return "standard.m4a"
        case .glass:
            return "glass.m4a"
        case .bamboo:
            return "bamboo.m4a"
        case .note:
            return "note.m4a"
        case .forSure:
            return "ForSure.m4r"
        case .beyondDoubt:
            return "Beyond Doubt.m4r"
        case .alert:
            return "Alert 2.m4a"
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
        let filename = sound.soundName.components(separatedBy: ".")
        guard
            let name = filename.first,
            let ext = filename.last,
            let url = Bundle.main.url(forResource: name, withExtension: ext),
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
