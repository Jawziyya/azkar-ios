//
//  Preferences.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 03.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine

let defaultMorningNotificationTime: Date = {
    let components = DateComponents(calendar: Calendar.current, hour: 8)
    return components.date ?? Date()
}()

let defaultEveningNotificationTime: Date = {
    let components = DateComponents(calendar: Calendar.current, hour: 18)
    return components.date ?? Date()
}()

final class Preferences: ObservableObject {

    @Preference(Keys.expandTranslation, defaultValue: true)
    var expandTranslation: Bool

    @Preference(Keys.expandTransliteration, defaultValue: true)
    var expandTransliteration: Bool

    @Preference(Keys.arabicFont, defaultValue: .noto)
    var arabicFont: ArabicFont

    @Preference(Keys.theme, defaultValue: .automatic)
    var theme: Theme

    @Preference(Keys.enableNotifications, defaultValue: false)
    var enableNotifications: Bool

    @Preference(Keys.morningNotificationsTime, defaultValue: defaultMorningNotificationTime)
    var morningNotificationTime: Date

    @Preference(Keys.eveningNotificationsTime, defaultValue: defaultEveningNotificationTime)
    var eveningNotificationTime: Date

    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .sink { _ in
                self.objectWillChange.send()
            }
    }
    
}
