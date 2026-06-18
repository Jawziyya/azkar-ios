import Foundation
import BackgroundTasks
import Entities
import FactoryKit
import Library
import DatabaseInteractors

final class NotificationsScheduler {

    @Injected(\.preferences) var preferences: Preferences
    @Injected(\.notificationsHandler) var notificationsHandler: NotificationsHandler

    static let backgroundRefreshTaskIdentifier = "io.jawziyya.azkar-app.reminders.refresh"

    private var database: AzkarDatabase {
        AzkarDatabase(language: preferences.contentLanguage)
    }

    private func quoteCategory(for category: NotificationCategory) -> NotificationQuoteCategory {
        switch category {
        case .morning, .evening:
            return .adhkar
        case .jumua:
            return .jumua
        }
    }

    func rescheduleAll() {
        notificationsHandler.removeScheduledNotifications()

        var reminders: [(id: String, category: NotificationCategory, fireTime: Date, quoteCategory: NotificationQuoteCategory, selection: ReminderTitleSelection, sound: ReminderSound, isDaily: Bool)] = []

        if preferences.enableMorningReminder {
            reminders.append((
                id: Keys.morningReminderId,
                category: .morning,
                fireTime: preferences.morningNotificationTime,
                quoteCategory: .adhkar,
                selection: preferences.morningReminderTitle,
                sound: preferences.morningReminderSound,
                isDaily: true
            ))
        }

        if preferences.enableEveningReminder {
            reminders.append((
                id: Keys.eveningReminderId,
                category: .evening,
                fireTime: preferences.eveningNotificationTime,
                quoteCategory: .adhkar,
                selection: preferences.eveningReminderTitle,
                sound: preferences.eveningReminderSound,
                isDaily: true
            ))
        }

        if preferences.enableJumuaReminder {
            reminders.append((
                id: Keys.jumuaReminderId,
                category: .jumua,
                fireTime: preferences.jumuaReminderTime,
                quoteCategory: .jumua,
                selection: preferences.jumuaReminderTitle,
                sound: preferences.jumuahDuaReminderSound,
                isDaily: false
            ))
        }

        // iOS only keeps up to 64 pending local notifications; anything beyond
        // that is silently dropped. Fixed reminders (.default / .quote) use one
        // repeating request each. The remaining budget is distributed across the
        // random reminders weighted by how often each fires, so every category
        // covers roughly the same span of days — otherwise a weekly reminder
        // (Jumua) would stretch far past the daily ones and dominate the tail.
        let maxPendingNotifications = 64
        let randomReminders = reminders.filter { $0.selection == .random }
        let fixedSlotCount = reminders.count - randomReminders.count
        let remaining = max(0, maxPendingNotifications - fixedSlotCount)

        var slotsByReminderId: [String: Int] = [:]
        if !randomReminders.isEmpty, remaining > 0 {
            // Days between occurrences: daily reminders fire every day, Jumua weekly.
            let cadenceInDays: (Bool) -> Double = { isDaily in isDaily ? 1 : 7 }
            // Notifications-per-day weight; the common horizon = budget / total weight.
            let totalWeight = randomReminders.reduce(0.0) { $0 + 1.0 / cadenceInDays($1.isDaily) }
            let horizonDays = Double(remaining) / totalWeight

            for reminder in randomReminders {
                let slots = Int((horizonDays / cadenceInDays(reminder.isDaily)).rounded())
                slotsByReminderId[reminder.id] = max(1, slots)
            }

            // Never exceed the budget; trim the largest allocation if rounding overshot.
            var scheduled = slotsByReminderId.values.reduce(0, +)
            while scheduled > remaining,
                  let key = slotsByReminderId.max(by: { $0.value < $1.value })?.key {
                slotsByReminderId[key]? -= 1
                scheduled -= 1
            }
        }

        var hasRandom = false

        for reminder in reminders {
            switch reminder.selection {
            case .default:
                scheduleDefault(reminder)
            case .quote(let id):
                scheduleQuote(reminder, quoteId: id)
            case .random:
                hasRandom = true
                let slots = slotsByReminderId[reminder.id] ?? 0
                if reminder.category == .jumua {
                    scheduleJumuaRandom(reminder, slots: slots)
                } else {
                    scheduleAdhkarRandom(reminder, windowDays: slots)
                }
            }
        }

        if hasRandom {
            scheduleBackgroundRefresh()
        }
    }

    private func quoteBody(text: String, source: String?) -> String {
        if let source, !source.isEmpty {
            return "\(text) (\(source))"
        }
        return text
    }

    private func scheduleDefault(_ reminder: (id: String, category: NotificationCategory, fireTime: Date, quoteCategory: NotificationQuoteCategory, selection: ReminderTitleSelection, sound: ReminderSound, isDaily: Bool)) {
        if reminder.isDaily {
            notificationsHandler.scheduleNotification(
                id: reminder.id,
                date: reminder.fireTime,
                title: reminder.category.defaultNotificationTitle,
                subtitle: nil,
                category: reminder.category,
                sound: reminder.sound
            )
        } else {
            var components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: reminder.fireTime)
            components.weekday = 6
            notificationsHandler.scheduleNotification(
                id: reminder.id,
                title: reminder.category.defaultNotificationTitle,
                subtitle: nil,
                dateComponents: components,
                category: reminder.category,
                sound: reminder.sound
            )
        }
    }

    private func scheduleQuote(_ reminder: (id: String, category: NotificationCategory, fireTime: Date, quoteCategory: NotificationQuoteCategory, selection: ReminderTitleSelection, sound: ReminderSound, isDaily: Bool), quoteId: Int) {
        guard let quote = try? database.getNotificationQuote(id: quoteId) else {
            scheduleDefault(reminder)
            return
        }
        if reminder.isDaily {
            notificationsHandler.scheduleNotification(
                id: reminder.id,
                date: reminder.fireTime,
                body: quoteBody(text: quote.text, source: quote.source),
                category: reminder.category,
                sound: reminder.sound
            )
        } else {
            var components = Calendar.current.dateComponents([.hour, .minute, .weekday], from: reminder.fireTime)
            components.weekday = 6
            notificationsHandler.scheduleNotification(
                id: reminder.id,
                body: quoteBody(text: quote.text, source: quote.source),
                dateComponents: components,
                category: reminder.category,
                sound: reminder.sound
            )
        }
    }

    private func scheduleJumuaRandom(_ reminder: (id: String, category: NotificationCategory, fireTime: Date, quoteCategory: NotificationQuoteCategory, selection: ReminderTitleSelection, sound: ReminderSound, isDaily: Bool), slots: Int) {
        guard let quotes = try? database.getNotificationQuotes(category: .jumua), !quotes.isEmpty else {
            scheduleDefault(reminder)
            return
        }

        let pool = quotes.shuffled()
        let calendar = Calendar.current
        let fireComponents = calendar.dateComponents([.hour, .minute], from: reminder.fireTime)
        let now = Date()

        for i in 0..<slots {
            guard let nextFriday = calendar.nextDate(
                after: now,
                matching: DateComponents(weekday: 6),
                matchingPolicy: .nextTime,
                repeatedTimePolicy: .first,
                direction: .forward
            ) else {
                continue
            }

            let targetDate: Date
            if i == 0 {
                targetDate = nextFriday
            } else {
                let daysToAdd = i * 7
                targetDate = calendar.date(byAdding: .day, value: daysToAdd, to: nextFriday) ?? nextFriday
            }

            var dateComponents = calendar.dateComponents([.year, .month, .day], from: targetDate)
            dateComponents.hour = fireComponents.hour
            dateComponents.minute = fireComponents.minute

            guard let fireDate = calendar.date(from: dateComponents), fireDate > now else {
                continue
            }

            let quote = pool[i % pool.count]
            let notificationId = "\(reminder.id).random.\(i)"

            notificationsHandler.scheduleNotification(
                id: notificationId,
                body: quoteBody(text: quote.text, source: quote.source),
                fireDate: fireDate,
                category: reminder.category,
                sound: reminder.sound
            )
        }
    }

    private func scheduleAdhkarRandom(_ reminder: (id: String, category: NotificationCategory, fireTime: Date, quoteCategory: NotificationQuoteCategory, selection: ReminderTitleSelection, sound: ReminderSound, isDaily: Bool), windowDays: Int) {
        guard let quotes = try? database.getNotificationQuotes(category: .adhkar), !quotes.isEmpty else {
            scheduleDefault(reminder)
            return
        }

        let pool = quotes.shuffled()
        let calendar = Calendar.current
        let fireComponents = calendar.dateComponents([.hour, .minute], from: reminder.fireTime)
        let now = Date()

        for i in 0..<windowDays {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
            dateComponents.hour = fireComponents.hour
            dateComponents.minute = fireComponents.minute

            guard var baseDate = calendar.date(from: dateComponents) else {
                continue
            }
            if i > 0 {
                baseDate = calendar.date(byAdding: .day, value: i, to: baseDate) ?? baseDate
            }

            guard baseDate > now else {
                continue
            }

            let quote = pool[i % pool.count]
            let notificationId = "\(reminder.id).random.\(i)"

            notificationsHandler.scheduleNotification(
                id: notificationId,
                body: quoteBody(text: quote.text, source: quote.source),
                fireDate: baseDate,
                category: reminder.category,
                sound: reminder.sound
            )
        }
    }

    func scheduleBackgroundRefresh() {
        #if !targetEnvironment(macCatalyst)
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: Self.backgroundRefreshTaskIdentifier)
            request.earliestBeginDate = Date(timeIntervalSinceNow: 12 * 3600)
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Failed to schedule background refresh: \(error)")
            }
        }
        #endif
    }
}
