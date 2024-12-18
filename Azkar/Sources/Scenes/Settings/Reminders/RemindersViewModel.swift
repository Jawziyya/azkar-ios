import Foundation
import Library

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
    
    func navigateToAdhkarReminders() {
        router.trigger(.adhkarReminders)
    }
    
    func navigateToJumuaReminders() {
        router.trigger(.jumuaReminders)
    }
    
    func enableReminders(_ flag: Bool) {
        preferences.enableNotifications = flag
    }
        
}
