import Foundation
import Library

/// Base view model for settings child sections.
class SettingsSectionViewModel: PreferencesDependantViewModel {
    let router: UnownedRouteTrigger<SettingsRoute>
    init(
        preferences: Preferences = .shared,
        router: UnownedRouteTrigger<SettingsRoute>
    ) {
        self.router = router
        super.init(preferences: preferences)
    }
}
