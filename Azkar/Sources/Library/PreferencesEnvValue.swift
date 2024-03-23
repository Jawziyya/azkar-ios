import SwiftUI

private struct PreferencesEnvKey: EnvironmentKey {
    static let defaultValue: Preferences = Preferences.shared
}

extension EnvironmentValues {
    var preferences: Preferences {
        get { self[PreferencesEnvKey.self] }
        set { self[PreferencesEnvKey.self] = newValue }
    }
}
