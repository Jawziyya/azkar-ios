// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine

final class AdhkarRemindersViewModel: ObservableObject {
    
    @Published var isNotificationsEnabled: Bool
    @Published var morningDate = Date()
    @Published var eveningDate = Date()
    @Published var morningTime: String = ""
    @Published var eveningTime: String = ""
    
    private let preferences: Preferences
    private let formatter: DateFormatter
    private var cancellables = Set<AnyCancellable>()
    let soundPickerViewModel: ReminderSoundPickerViewModel
    
    init(
        preferences: Preferences = .shared,
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create(),
        subscribeScreenTrigger: @escaping Action
    ) {
        self.preferences = preferences
        isNotificationsEnabled = preferences.enableAdhkarReminder
        soundPickerViewModel = ReminderSoundPickerViewModel(
            preferredSound: preferences.adhkarReminderSound,
            subscriptionManager: subscriptionManager,
            subscribeScreenTrigger: subscribeScreenTrigger
        )
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.formatter = formatter
        
        morningTime = formatter.string(from: preferences.morningNotificationTime)
        eveningTime = formatter.string(from: preferences.eveningNotificationTime)
        
        $isNotificationsEnabled
            .assign(to: \.enableAdhkarReminder, on: preferences)
            .store(in: &cancellables)
        
        soundPickerViewModel.$preferredSound
            .assign(to: \.adhkarReminderSound, on: preferences)
            .store(in: &cancellables)
        
        soundPickerViewModel.$preferredSound.eraseToAnyPublisher().toVoid()
            .sink(receiveValue: { [weak self] in
                self?.objectWillChange.send()
            })
            .store(in: &cancellables)
    }
    
    var morningNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 2, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 12, minute: 0).date ?? Date()
        return minDate ... maxDate
    }
    
    var eveningNotificationDateRange: ClosedRange<Date> {
        let minDate = DateComponents(calendar: Calendar.current, hour: 13, minute: 0).date ?? Date()
        let maxDate = DateComponents(calendar: Calendar.current, hour: 16, minute: 0).date ?? Date()
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
    }
    
    func setEveningTime(_ time: String) {
        preferences.eveningNotificationTime = formatter.date(from: eveningTime) ?? defaultEveningNotificationTime
    }
    
}
