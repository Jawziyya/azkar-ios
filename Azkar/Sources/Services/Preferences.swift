//
//  Preferences.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 03.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

let defaultMorningNotificationTime: Date = {
    let components = DateComponents(calendar: Calendar.current, hour: 8)
    return components.date ?? Date()
}()

let defaultEveningNotificationTime: Date = {
    let components = DateComponents(calendar: Calendar.current, hour: 18)
    return components.date ?? Date()
}()

let defaultJumuaReminderTime: Date = {
    let components = DateComponents(calendar: Calendar.current, hour: 15, weekday: 5)
    return components.date ?? Date()
}()

final class Preferences {
    
    static var shared = Preferences()

    @Preference(Keys.enableFunFeatures, defaultValue: true)
    var enableFunFeatures: Bool

    @Preference(Keys.expandTranslation, defaultValue: true)
    var expandTranslation: Bool

    @Preference(Keys.expandTransliteration, defaultValue: true)
    var expandTransliteration: Bool

    @Preference(Keys.arabicFont, defaultValue: .noto)
    var arabicFont: ArabicFont

    @Preference(Keys.showTashkeel, defaultValue: true)
    var showTashkeel

    @Preference(Keys.theme, defaultValue: .automatic)
    var theme: Theme
    
    @Preference(Keys.colorTheme, defaultValue: ColorTheme.default)
    var colorTheme: ColorTheme

    @Preference(Keys.enableReminders, defaultValue: false)
    var enableNotifications: Bool
    
    @Preference(Keys.enableAdhkarReminder, defaultValue: true)
    var enableAdhkarReminder: Bool
    
    @Preference(Keys.enableJumuaReminder, defaultValue: true)
    var enableJumuaReminder: Bool
    
    @Preference(Keys.jumuaReminderTime, defaultValue: defaultJumuaReminderTime)
    var jumuaReminderTime: Date
    
    @Preference(Keys.morningNotificationsTime, defaultValue: defaultMorningNotificationTime)
    var morningNotificationTime: Date

    @Preference(Keys.eveningNotificationsTime, defaultValue: defaultEveningNotificationTime)
    var eveningNotificationTime: Date

    @Preference(Keys.appIcon, defaultValue: AppIcon.gold)
    var appIcon: AppIcon

    @Preference(Keys.useSystemFontSize, defaultValue: true)
    var useSystemFontSize

    @Preference(Keys.purchasedIconPacks, defaultValue: [AppIconPack.standard])
    var purchasedIconPacks

    @Preference(Keys.sizeCategory, defaultValue: ContentSizeCategory.medium)
    var sizeCategory
    
    @Preference(Keys.preferredFont, defaultValue: AppFont.iowanOldStyle)
    var preferredFont: AppFont
    
    @Preference(Keys.preferredAdhkarReminderSound, defaultValue: ReminderSound.standard)
    var adhkarReminderSound: ReminderSound
    
    @Preference(Keys.preferredJumuahReminderSound, defaultValue: ReminderSound.standard)
    var jumuahDuaReminderSound: ReminderSound
    
    @Preference(Keys.enableProFeatures, defaultValue: false)
    var enableProFeatures: Bool
    
    private var notificationSubscription: AnyCancellable?

    func storageChangesPublisher() -> AnyPublisher<Void, Never> {
        return NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
