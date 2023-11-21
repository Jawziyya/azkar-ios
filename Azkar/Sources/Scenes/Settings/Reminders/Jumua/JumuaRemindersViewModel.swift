// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Combine

final class JumuaRemindersViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled = true
    
    let router: UnownedRouteTrigger<SettingsRoute>
    let soundPickerViewModel: ReminderSoundPickerViewModel
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(observationType: .soundAccess, didChangeCallback: objectWillChange.send)
    var preferences: Preferences
    private var cancellables = Set<AnyCancellable>()
    
    init(
        preferences: Preferences = Preferences.shared,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        router: UnownedRouteTrigger<SettingsRoute>
    ) {
        self.preferences = preferences
        self.router = router
        isNotificationsEnabled = preferences.enableJumuaReminder
        soundPickerViewModel = ReminderSoundPickerViewModel(
            preferredSound: preferences.jumuahDuaReminderSound,
            subscriptionManager: subscriptionManager,
            subscribeScreenTrigger: {
                router.trigger(.subscribe)
            }
        )
        
        $isNotificationsEnabled
            .assign(to: \.enableJumuaReminder, on: preferences)
            .store(in: &cancellables)
    }
    
    func presentSoundPicker() {
        router.trigger(.soundPicker(preferences.jumuahDuaReminderSound))
    }
    
    var notificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 10, minute: 0).date ?? Date()
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
    
}
