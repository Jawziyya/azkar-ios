// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import UserNotifications
import AudioPlayer

enum ReminderSound: String, Identifiable, Equatable, Codable {
    
    case standard, glass, bamboo, note
    case forSure, beyondDoubt, purr, twitter, pristine, deduction, timeIsNow, quiteImpressed
    
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
            return "Time Is Now"
        case .quiteImpressed:
            return "Quite Impressed"
        default:
            return rawValue.capitalized
        }
    }
    
    var fileName: String {
        if #available(iOS 17, *), self == .standard {
            return "rebound.mp3"
        } else {
            return rawValue + "." + soundFileFormat
        }
    }
    
    var soundFileFormat: String {
        switch self {
        case .standard, .glass, .bamboo, .note, .purr, .twitter:
            return "m4a"
        case .forSure, .beyondDoubt, .pristine, .deduction, .timeIsNow, .quiteImpressed:
            return "m4r"
        }
    }
    
    var link: String? {
        switch self {
            
        case .beyondDoubt:
            return "https://notificationsounds.com/notification-sounds/beyond-doubt-580"
            
        case .forSure:
            return "https://notificationsounds.com/notification-sounds/for-sure-576"
            
        case .pristine:
            return "https://notificationsounds.com/message-tones/pristine-609"
            
        case .deduction:
            return "https://notificationsounds.com/notification-sounds/deduction-588"
            
        case .timeIsNow:
            return "https://notificationsounds.com/notification-sounds/time-is-now-585"
            
        case .quiteImpressed:
            return "https://notificationsounds.com/notification-sounds/quite-impressed-565"
            
        default:
            return nil
        }
    }
    
}

extension ReminderSound {
    
    var notificationSound: UNNotificationSound {
        switch self {
        case .standard:
            return UNNotificationSound.default
        default:
            return UNNotificationSound(named: UNNotificationSoundName(fileName))
        }
    }
    
}

final class ReminderSoundPickerViewModel: ObservableObject {
    
    enum Section: String, Equatable, Identifiable, CaseIterable {
        case standard, custom
        
        var title: String {
            return NSLocalizedString("settings.reminders.sounds." + rawValue, comment: "")
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

    private let subscribeScreenTrigger: Action
    private let subscriptionManager: SubscriptionManagerType
    
    init(
        preferredSound: ReminderSound,
        subscriptionManager: SubscriptionManagerType,
        subscribeScreenTrigger: @escaping Action
    ) {
        self.preferredSound = preferredSound
        self.subscriptionManager = subscriptionManager
        self.subscribeScreenTrigger = subscribeScreenTrigger
    }
    
    private let player = AudioPlayer()
    
    @Published var preferredSound: ReminderSound
    
    static var placeholder: ReminderSoundPickerViewModel {
        return ReminderSoundPickerViewModel(
            preferredSound: ReminderSound.standard,
            subscriptionManager: DemoSubscriptionManager(),
            subscribeScreenTrigger: {}
        )
    }
    
    func playSound(_ sound: ReminderSound) {
        guard
            let url = Bundle.main.url(forResource: sound.fileName, withExtension: ""),
            let audioItem = AudioItem(soundURLs: [.high: url]) else {
            return
        }
        player.pause()
        player.play(item: audioItem)
    }
    
    func setPreferredSound(_ sound: ReminderSound) {
        if subscriptionManager.isProUser() || ReminderSound.standardSounds.contains(sound) {
            self.preferredSound = sound
        } else {
            subscribeScreenTrigger()
        }
    }
    
}
