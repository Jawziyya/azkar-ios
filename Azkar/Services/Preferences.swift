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

final class Preferences {

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

    @Preference(Keys.enableNotifications, defaultValue: false)
    var enableNotifications: Bool

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

    private var notificationSubscription: AnyCancellable?

    func storageChangesPublisher() -> AnyPublisher<Void, Never> {
        return NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

}
