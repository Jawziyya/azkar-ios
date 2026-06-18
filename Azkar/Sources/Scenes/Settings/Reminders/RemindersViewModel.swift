import SwiftUI
import Combine
import FactoryKit
import Library
import Entities
import DatabaseInteractors

@MainActor
final class RemindersViewModel: ObservableObject {
    
    // MARK: - Common properties
    let navigator: any SettingsNavigationRouting
    @Injected(\.preferences) var preferences: Preferences
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(observationType: .soundAccess, didChangeCallback: objectWillChange.send)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Adhkar Reminders properties
    @Published var morningTime: String = ""
    @Published var eveningTime: String = ""
    @Published var jumuaReminderTime: String = ""
    private let formatter: DateFormatter
    
    // MARK: - Initialization
    
    init(navigator: any SettingsNavigationRouting) {
        self.navigator = navigator
        
        // Adhkar reminders initialization
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self.formatter = formatter
        
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
        jumuaReminderTime = formatter.string(from: preferences.jumuaReminderTime)
        
        Publishers.MergeMany(
            preferences.$enableMorningReminder.toVoid(),
            preferences.$enableEveningReminder.toVoid(),
            preferences.$enableJumuaReminder.toVoid(),
            preferences.$morningNotificationTime.toVoid(),
            preferences.$eveningNotificationTime.toVoid(),
            preferences.$morningReminderSound.toVoid(),
            preferences.$eveningReminderSound.toVoid(),
            preferences.$jumuahDuaReminderSound.toVoid(),
            preferences.$morningReminderTitle.toVoid(),
            preferences.$eveningReminderTitle.toVoid(),
            preferences.$jumuaReminderTitle.toVoid()
        )
        .eraseToAnyPublisher()
        .receive(on: RunLoop.main)
        .sink(receiveValue: { [unowned self] _ in
            withAnimation(.smooth) {
                objectWillChange.send()
            }
        })
        .store(in: &cancellables)
    }
    
    // MARK: - Common methods
    
    func navigateToNotificationsList() {
        navigator.show(.notificationsList)
    }
    
    // MARK: - Adhkar Reminders methods
    
    func presentMorningSoundPicker() {
        navigator.show(.soundPicker(.init(sound: preferences.morningReminderSound, type: .morning)))
    }

    func presentEveningSoundPicker() {
        navigator.show(.soundPicker(.init(sound: preferences.eveningReminderSound, type: .evening)))
    }

    func presentMorningTitlePicker() {
        navigator.show(.reminderTitlePicker(.init(selection: preferences.morningReminderTitle, type: .morning)))
    }

    func presentEveningTitlePicker() {
        navigator.show(.reminderTitlePicker(.init(selection: preferences.eveningReminderTitle, type: .evening)))
    }
    
    private func referenceTime(hour: Int, minute: Int = 0) -> Date {
        DateComponents(calendar: Calendar.current, hour: hour, minute: minute).date ?? Date()
    }

    // The only constraint is that the morning reminder may not be later than the
    // evening one. Morning is allowed anywhere from the start of the day up to the
    // currently selected evening time.
    var morningNotificationDateRange: ClosedRange<Date> {
        let minDate = referenceTime(hour: 0, minute: 0)
        let maxDate = preferences.eveningNotificationTime
        return minDate ... max(minDate, maxDate)
    }

    // Evening is allowed anywhere from the currently selected morning time up to
    // the end of the day.
    var eveningNotificationDateRange: ClosedRange<Date> {
        let minDate = preferences.morningNotificationTime
        let maxDate = referenceTime(hour: 23, minute: 59)
        return min(minDate, maxDate) ... maxDate
    }

    func getDatesRange(fromHour hour: Int, hours: Int) -> [Date] {
        let now = DateComponents(calendar: Calendar.current, hour: hour, minute: 0).date ?? Date()
        return (1...(hours * 2)).reduce(into: [now]) { (dates, multiplier) in
            let duration = DateComponents(calendar: Calendar.current, minute: multiplier * 30)
            let newDate = Calendar.current.date(byAdding: duration, to: now) ?? now
            dates.append(newDate)
        }
    }

    /// All half-hour slots of the day that fall within the given range. Used by the
    /// Mac time pickers, which present a list instead of an inline `DatePicker`.
    private func halfHourSlots(in range: ClosedRange<Date>) -> [Date] {
        let dayStart = referenceTime(hour: 0, minute: 0)
        return (0...47).compactMap { index -> Date? in
            let date = Calendar.current.date(byAdding: .minute, value: index * 30, to: dayStart) ?? dayStart
            return range.contains(date) ? date : nil
        }
    }

    var morningDateItems: [String] {
        return halfHourSlots(in: morningNotificationDateRange).compactMap(formatter.string)
    }

    var eveningDateItems: [String] {
        return halfHourSlots(in: eveningNotificationDateRange).compactMap(formatter.string)
    }
    
    func setMorningTime(_ time: String) {
        preferences.morningNotificationTime = formatter.date(from: morningTime) ?? defaultMorningNotificationTime
        morningTime = formatter.string(from: preferences.morningNotificationTime)
    }

    func setEveningTime(_ time: String) {
        preferences.eveningNotificationTime = formatter.date(from: eveningTime) ?? defaultEveningNotificationTime
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
    }
    
    // MARK: - Jumua Reminders methods
    
    var jumuaDateItems: [String] {
        return getDatesRange(fromHour: 12, hours: 18).compactMap(formatter.string)
    }
    
    func setJumuaReminderTime(_ time: String) {
        preferences.jumuaReminderTime = formatter.date(from: jumuaReminderTime) ?? defaultJumuaReminderTime
        jumuaReminderTime = formatter.string(from: preferences.jumuaReminderTime)
    }
    
    func presentJumuaSoundPicker() {
        navigator.show(.soundPicker(.init(sound: preferences.jumuahDuaReminderSound, type: .jumua)))
    }

    func presentJumuaTitlePicker() {
        navigator.show(.reminderTitlePicker(.init(selection: preferences.jumuaReminderTitle, type: .jumua)))
    }
    
    private func titleSelectionLabel(for selection: ReminderTitleSelection) -> String {
        switch selection {
        case .default:
            return String(localized: "common.default")
        case .random:
            return String(localized: "common.random")
        case .quote:
            // A picked quote is too long to display inline; the chevron lets the
            // user open the picker to see the chosen quote.
            return ""
        }
    }

    func morningTitleLabel() -> String {
        titleSelectionLabel(for: preferences.morningReminderTitle)
    }

    func eveningTitleLabel() -> String {
        titleSelectionLabel(for: preferences.eveningReminderTitle)
    }

    func jumuaTitleLabel() -> String {
        titleSelectionLabel(for: preferences.jumuaReminderTitle)
    }
    
    var jumuaNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 10, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 18, minute: 0).date ?? Date()
        return minDate ... maxDate
    }
    
}
