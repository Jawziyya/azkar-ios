import Foundation
import Combine
import Library

final class RemindersViewModel: ObservableObject {
    
    // MARK: - Common properties
    let router: UnownedRouteTrigger<SettingsRoute>
    var preferences: Preferences
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(observationType: .soundAccess, didChangeCallback: objectWillChange.send)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Adhkar Reminders properties
    @Published var isAdhkarNotificationsEnabled: Bool
    @Published var morningTime: String = ""
    @Published var eveningTime: String = ""
    private let formatter: DateFormatter
    
    // MARK: - Jumua Reminders properties
    @Published var isJumuaNotificationsEnabled = true
    let jumuaSoundPickerViewModel: ReminderSoundPickerViewModel
    
    // MARK: - Initialization
    
    init(
        preferences: Preferences = .shared,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        router: UnownedRouteTrigger<SettingsRoute>
    ) {
        self.preferences = preferences
        self.router = router
        
        // Adhkar reminders initialization
        isAdhkarNotificationsEnabled = preferences.enableAdhkarReminder
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self.formatter = formatter
        
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
        
        // Jumua reminders initialization
        isJumuaNotificationsEnabled = preferences.enableJumuaReminder
        jumuaSoundPickerViewModel = ReminderSoundPickerViewModel(
            preferredSound: preferences.jumuahDuaReminderSound,
            subscriptionManager: subscriptionManager,
            subscribeScreenTrigger: {
                router.trigger(.subscribe(sourceScreen: "RemindersScreen"))
            }
        )
        
        // Set up Publishers
        $isAdhkarNotificationsEnabled
            .assign(to: \.enableAdhkarReminder, on: preferences)
            .store(in: &cancellables)
            
        $isJumuaNotificationsEnabled
            .assign(to: \.enableJumuaReminder, on: preferences)
            .store(in: &cancellables)
    }
    
    // MARK: - Common methods
    
    func navigateToNotificationsList() {
        router.trigger(.notificationsList)
    }
    
    // MARK: - Adhkar Reminders methods
    
    func presentAdhkarSoundPicker() {
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
    
    // MARK: - Jumua Reminders methods
    
    func presentJumuaSoundPicker() {
        router.trigger(.soundPicker(preferences.jumuahDuaReminderSound))
    }
    
    var jumuaNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 10, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 18, minute: 0).date ?? Date()
        return minDate ... maxDate
    }
    
}
