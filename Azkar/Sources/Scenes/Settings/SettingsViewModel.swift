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
import Entities
import Library

final class SettingsViewModel: ObservableObject {
    
    enum SettingsMode {
        case standart, text
    }
    
    private let notificationsHandler: NotificationsHandler
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(observationType: .generalAccess, didChangeCallback: objectWillChange.send)

    var canChangeIcon: Bool {
        return !UIDevice.current.isMac
    }
    
    var canChangeLanguage: Bool {
        return mode == .standart
    }

    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }
    
    func getFontsViewModel(fontsType: FontsType) -> FontsViewModel {
        FontsViewModel(fontsType: fontsType, service: FontsService(), subscribeScreenTrigger: { [unowned self] in
            self.router.trigger(.subscribe)
        })
    }
    
    var colorSchemeViewModel: ColorSchemesViewModel {
        ColorSchemesViewModel(preferences: preferences, subscribeScreenTrigger: { [unowned self] in
            self.router.trigger(.subscribe)
        })
    }
    
    var adhkarRemindersViewModel: AdhkarRemindersViewModel {
        AdhkarRemindersViewModel(preferences: preferences, subscribeScreenTrigger: { [unowned self] in
            self.router.trigger(.subscribe)
        })
    }
    
    var jumuaRemindersViewModel: JumuaRemindersViewModel {
        JumuaRemindersViewModel(preferences: preferences, subscribeScreenTrigger: { [unowned self] in
            self.router.trigger(.subscribe)
        })
    }

    var selectedArabicFontSupportsVowels: Bool {
        return preferences.preferredArabicFont.hasTashkeelSupport
    }
    
    private let formatter: DateFormatter

    var preferences: Preferences
    private let databaseService: DatabaseService
    
    var themeTitle: String {
        "\(preferences.theme.title), \(preferences.colorTheme.title)"
    }

    private var cancellables = Set<AnyCancellable>()
    private unowned let router: RootRouter
    let mode: SettingsMode

    init(
        mode: SettingsMode = .standart,
        databaseService: DatabaseService,
        preferences: Preferences,
        notificationsHandler: NotificationsHandler = .shared,
        router: RootRouter
    ) {
        self.mode = mode
        self.databaseService = databaseService
        self.preferences = preferences
        self.notificationsHandler = notificationsHandler
        self.router = router

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
            .store(in: &cancellables)

        setupNotificationsRescheduler()
    }

    /// Observes some preferences to reschedule notifications if needed.
    private func setupNotificationsRescheduler() {
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
            .receive(on: DispatchQueue.main)
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [unowned self] in
                self.notificationsHandler.removeScheduledNotifications()
                self.scheduleNotifications()
            })
            .store(in: &cancellables)
    }
    
    func enableReminders(_ flag: Bool) {
        preferences.enableNotifications = flag
    }

    func navigateToNotificationsList() {
        router.trigger(.notificationsList)
    }

    private func scheduleNotifications() {
        guard preferences.enableNotifications else {
            return
        }

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
    
    func getAvailableLanguages() -> [Language] {
        return Language.allCases.filter(databaseService.translationExists(for:))
    }
    
}
