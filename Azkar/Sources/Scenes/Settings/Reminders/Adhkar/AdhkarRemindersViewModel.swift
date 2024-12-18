import Foundation
import Combine
import Library

final class AdhkarRemindersViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled: Bool
    @Published var morningTime: String = ""
    @Published var eveningTime: String = ""
    
    var preferences: Preferences
    private let formatter: DateFormatter
    private let router: UnownedRouteTrigger<SettingsRoute>
    private var cancellables = Set<AnyCancellable>()
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(observationType: .soundAccess, didChangeCallback: objectWillChange.send)
    
    init(
        preferences: Preferences = .shared,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        router: UnownedRouteTrigger<SettingsRoute>
    ) {
        self.preferences = preferences
        self.router = router
        isNotificationsEnabled = preferences.enableAdhkarReminder
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.formatter = formatter
        
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
        
        $isNotificationsEnabled
            .assign(to: \.enableAdhkarReminder, on: preferences)
            .store(in: &cancellables)
    }
    
    func presentSoundPicker() {
        router.trigger(.soundPicker(preferences.adhkarReminderSound))
    }
    
    var morningNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 2, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 12, minute: 0).date ?? Date()
        return minDate ... maxDate
    }
    
    var eveningNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 13, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 18, minute: 0).date ?? Date()
        return minDate ... maxDate
    }

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
        return getDatesRange(fromHour: 12, hours: 16).compactMap(formatter.string)
    }
    
    func setMorningTime(_ time: String) {
        preferences.morningNotificationTime = formatter.date(from: morningTime) ?? defaultMorningNotificationTime
        morningTime = formatter.string(from: preferences.morningNotificationTime)
    }

    func setEveningTime(_ time: String) {
        preferences.eveningNotificationTime = formatter.date(from: eveningTime) ?? defaultEveningNotificationTime
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
    }
    
}
