// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

final class RemindersViewModel: ObservableObject {
    
    var preferences: Preferences
    private let router: UnownedRouteTrigger<SettingsRoute>
    
    lazy var notificationsDisabledViewModel: NotificationsDisabledViewModel = .init(
        observationType: .generalAccess, 
        didChangeCallback: objectWillChange.send
    )
    
    init(
        preferences: Preferences = Preferences.shared,
        router: UnownedRouteTrigger<SettingsRoute>
    ) {
        self.preferences = preferences
        self.router = router
    }
    
    func navigateToNotificationsList() {
        router.trigger(.notificationsList)
    }
    
    func enableReminders(_ flag: Bool) {
        preferences.enableNotifications = flag
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
    
}
