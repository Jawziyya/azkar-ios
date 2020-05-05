//
//  Preferences.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 03.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

final class Preferences: ObservableObject {

    @Preference("kExpandTranslation", defaultValue: false)
    var expandTranslation: Bool

    @Preference("kExpandTransliteration", defaultValue: false)
    var expandTransliteration: Bool

    @Preference("kArabicFont", defaultValue: .amiri)
    var arabicFont: ArabicFont

    @Preference("kTheme", defaultValue: .automatic)
    var theme: Theme

    @Preference("kEnableNotifications", defaultValue: false)
    var enableNotifications

    @Preference("kMorningNotificationsTime", defaultValue: Date())
    var morningNotificationsTime

    @Preference("kEveningNotificationsTime", defaultValue: Date())
    var eveningNotificationsTime

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .sink { _ in
                self.objectWillChange.send()
            }
    }
    
}
