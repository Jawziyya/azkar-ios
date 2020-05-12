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

enum ArabicFont: String, CaseIterable, Identifiable, Codable, Hashable, PickableItem {
    case standard, adobe, amiri, KFGQP, noto, scheherazade

    var fontName: String {
        switch self {
        case .standard:
            return "iOS"
        case .adobe:
            return "AdobeArabic-Regular"
        case .amiri:
            return "Amiri-Regular"
        case .KFGQP:
            return "KFGQPCUthmanicScriptHAFS"
        case .noto:
            return "NotoNaskhArabicUI"
        case .scheherazade:
            return "Scheherazade"
        }
    }

    var id: String {
        return rawValue
    }

    var title: String {
        switch self {
        case .adobe, .amiri:
            return rawValue.capitalized
        case .KFGQP:
            return rawValue
        case .noto:
            return "Noto Nashkh"
        default:
            return fontName
        }
    }

    var subtitle: String? {
        return "بسم الله"
    }

    var subtitleFont: Font {
        return Font.custom(fontName, size: textSize(forTextStyle: .callout))
    }

}

enum Theme: Int, Codable, CaseIterable, Identifiable, PickableItem, Hashable {
    case automatic, light, dark

    var id: Int {
        return rawValue
    }

    var title: String {
        switch self {
        case .automatic:
            return "Авто"
        case .light:
            return "Светлая"
        case .dark:
            return "Тёмная"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }

    var statusBarStyle: UIStatusBarStyle? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        }
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

}

enum AppIcon: String, Codable, CaseIterable, Hashable, PickableItem, Identifiable {
    case light, ink, dark, ramadan = "purple"

    static var availableIcons: [AppIcon] {
        return Array(allCases.prefix(3))
    }

    var iconName: String? {
        switch self {
        case .light:
            return nil
        default:
            return rawValue
        }
    }

    var title: String {
        switch self {
        case .light:
            return "Золото"
        case .ink:
            return "Чернила"
        case .dark:
            return "Тёмная ночь"
        case .ramadan:
            return "Рамадан"
        }
    }

    var id: String {
        rawValue
    }

    var image: Image? {
        Image(uiImage: UIImage(named: "ic_\(rawValue).png")!)
    }
}

final class SettingsViewModel: ObservableObject {

    let notificationsCenter = UNUserNotificationCenter.current()
    private let morningNotificationId = "morning.notification"
    private let eveningNotificationId = "evening.notification"

    var preferences: Preferences

    var canChangeIcon: Bool {
        return !UIDevice.current.isIpad
    }

    private let formatter: DateFormatter

    @Published var arabicFont: ArabicFont
    @Published var theme: Theme
    @Published var appIcon: AppIcon
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

    init(preferences: Preferences) {
        self.preferences = preferences

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.formatter = formatter
        appIcon = preferences.appIcon
        arabicFont = preferences.arabicFont
        theme = preferences.theme
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)

        let preferencesChange = preferences.objectWillChange
            .receive(on: RunLoop.main)
            .share()

        preferencesChange
            .map { _ in preferences.arabicFont }
            .assign(to: \.arabicFont, on: self)
            .store(in: &cancellabels)

        preferencesChange
            .map { _ in preferences.theme }
            .assign(to: \.theme, on: self)
            .store(in: &cancellabels)

        $appIcon
            .dropFirst(1)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { icon in
                preferences.appIcon = icon
                UIApplication.shared.setAlternateIconName(icon.iconName)
            })
            .store(in: &cancellabels)

        $morningTime
            .map { [unowned self] time in
                self.formatter.date(from: time) ?? defaultMorningNotificationTime
            }
            .assign(to: \.morningNotificationTime, on: preferences)
            .store(in: &cancellabels)

        $eveningTime
            .map { [unowned self] time in
                self.formatter.date(from: time) ?? defaultEveningNotificationTime
            }
            .assign(to: \.eveningNotificationTime, on: preferences)
            .store(in: &cancellabels)

        preferences.$enableNotifications.publisher()
            .sink { enabled in
                print(enabled)
            }
            .store(in: &cancellabels)

        Publishers.CombineLatest3(
                preferences.$enableNotifications.publisher(),
                preferences.$morningNotificationTime.publisher(),
                preferences.$eveningNotificationTime.publisher()
            )
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] (enabled, morning, evening) in
                self.removeScheduledNotifications()
                guard enabled else {
                    return
                }
                self.scheduleNotifications()
            })
            .store(in: &cancellabels)
    }

    private func removeScheduledNotifications() {
        notificationsCenter.removeDeliveredNotifications(withIdentifiers: [morningNotificationId, eveningNotificationId])
    }

    private func scheduleNotifications() {
        let morningRequest = notifiationRequest(id: morningNotificationId, date: preferences.morningNotificationTime, title: "Утренние азкары 🌅")
        let eveningRequest = notifiationRequest(id: eveningNotificationId, date: preferences.eveningNotificationTime, title: "Вечерние азкары 🌄")

        notificationsCenter.add(morningRequest, withCompletionHandler: nil)
        notificationsCenter.add(eveningRequest, withCompletionHandler: nil)
    }

    private func notifiationRequest(id: String, date: Date, title: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return request
    }

}
