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

    let objectWillChange = PassthroughSubject<Void, Never>()

    private let notificationsHandler: NotificationsHandler

    var canChangeIcon: Bool {
        return !UIDevice.current.isMac
    }

    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }

    private let formatter: DateFormatter

    var preferences: Preferences
    @Published var morningTime: String
    @Published var eveningTime: String

    func getDatesRange(fromHour hour: Int, hours: Int) -> [Date] {
        let now = DateComponents(calendar: Calendar.current, hour: hour, minute: 0).date ?? Date()
        return (1...(hours * 2)).reduce(into: [now]) { (dates, multiplier) in
            let duration = DateComponents(calendar: Calendar.current, minute: multiplier * 30)
            let newDate = Calendar.current.date(byAdding: duration, to: now) ?? now
            dates.append(newDate)
        }
    }

    var morningDateItems: [String] {
        return getDatesRange(fromHour: 2, hours: 11).compactMap(formatter.string)
    }

    var eveningDateItems: [String] {
        return getDatesRange(fromHour: 14, hours: 10).compactMap(formatter.string)
    }

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences, notificationsHandler: NotificationsHandler = .shared) {
        self.preferences = preferences
        self.notificationsHandler = notificationsHandler

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.formatter = formatter
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)

        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .subscribe(objectWillChange)
            .store(in: &cancellabels)

        $morningTime
            .dropFirst()
            .map { [unowned self] time in
                self.formatter.date(from: time) ?? defaultMorningNotificationTime
            }
            .assign(to: \.morningNotificationTime, on: preferences)
            .store(in: &cancellabels)

        $eveningTime
            .dropFirst()
            .map { [unowned self] time in
                self.formatter.date(from: time) ?? defaultEveningNotificationTime
            }
            .assign(to: \.eveningNotificationTime, on: preferences)
            .store(in: &cancellabels)

        Publishers.CombineLatest3(
                preferences.$enableNotifications,
                preferences.$morningNotificationTime,
                preferences.$eveningNotificationTime
            )
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (enabled, morning, evening) in
                self.notificationsHandler.removeScheduledNotifications()
                guard enabled else {
                    return
                }
                self.scheduleNotifications()
            })
            .store(in: &cancellabels)
    }

    private func scheduleNotifications() {
        notificationsHandler.scheduleNotification(id: Keys.morningNotificationId, date: preferences.morningNotificationTime, title: NSLocalizedString("notifications.morning-notification-title", comment: "Morning notification title."), categoryId: ZikrCategory.morning.rawValue)
        notificationsHandler.scheduleNotification(id: Keys.eveningNotificationId, date: preferences.eveningNotificationTime, title: NSLocalizedString("notifications.evening-notification-title", comment: "Evening notification title."), categoryId: ZikrCategory.evening.rawValue)
    }

}
