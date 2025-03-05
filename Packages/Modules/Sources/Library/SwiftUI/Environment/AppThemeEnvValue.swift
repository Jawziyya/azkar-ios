import SwiftUI

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = AppTheme.current
}

extension EnvironmentValues {
    public var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}
