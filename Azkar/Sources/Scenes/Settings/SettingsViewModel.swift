//
//  SettingsViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Combine
import UIKit
import UserNotifications

final class SettingsViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled = true

    private let notificationsHandler: NotificationsHandler

    var canChangeIcon: Bool {
        return !UIDevice.current.isMac
    }

    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }
    
    var fontsViewModel: FontsViewModel {
        FontsViewModel(service: FontsService())
    }
    
    var colorSchemeViewModel: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: preferences)
    }
    
    var adhkarRemindersViewModel: AdhkarRemindersViewModel {
        AdhkarRemindersViewModel(preferences: preferences)
    }
    
    var jumuaRemindersViewModel: JumuaRemindersViewModel {
        JumuaRemindersViewModel(preferences: preferences)
    }
    
    private let formatter: DateFormatter

    var preferences: Preferences
    
    var themeTitle: String {
        "\(preferences.theme.title), \(preferences.colorTheme.title)"
    }

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences, notificationsHandler: NotificationsHandler = .shared) {
        self.preferences = preferences
        self.notificationsHandler = notificationsHandler

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.formatter = formatter
        
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                self.objectWillChange.send()
            })
            .store(in: &cancellabels)
        
        Publishers.MergeMany(
                preferences.$enableNotifications.toVoid().dropFirst(),
                preferences.$enableAdhkarReminder.toVoid().dropFirst(),
                preferences.$morningNotificationTime.toVoid().dropFirst(),
                preferences.$eveningNotificationTime.toVoid().dropFirst(),
                preferences.$adhkarReminderSound.toVoid().dropFirst(),
                preferences.$enableJumuaReminder.toVoid().dropFirst(),
                preferences.$jumuaReminderTime.toVoid().dropFirst(),
                preferences.$jumuahDuaReminderSound.toVoid().dropFirst()
            )
            .receive(on: RunLoop.main)
            .debounce(for: 3, scheduler: RunLoop.main)
            .sink(receiveValue: { [unowned self] in
                self.notificationsHandler.removeScheduledNotifications()
                self.scheduleNotifications()
            })
            .store(in: &cancellabels)
    }

    private func scheduleNotifications() {
        if preferences.enableAdhkarReminder {
            notificationsHandler.scheduleNotification(
                id: Keys.morningReminderId,
                date: preferences.morningNotificationTime,
                titleKey: "notifications.morning-notification-title",
                categoryId: ZikrCategory.morning.rawValue,
                sound: preferences.adhkarReminderSound
            )
            notificationsHandler.scheduleNotification(
                id: Keys.eveningReminderId,
                date: preferences.eveningNotificationTime,
                titleKey: "notifications.evening-notification-title",
                categoryId: ZikrCategory.evening.rawValue,
                sound: preferences.adhkarReminderSound
            )
        }
        
        if preferences.enableJumuaReminder {
            var components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: preferences.jumuaReminderTime)
            components.weekday = 6 // Jumua (friday).
            notificationsHandler.scheduleNotification(
                id: Keys.jumuaReminderId,
                titleKey: "notifications.jumua.title",
                dateComponents: components,
                categoryId: "jumua",
                sound: preferences.jumuahDuaReminderSound
            )
        }
    }

}
