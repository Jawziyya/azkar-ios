import SwiftUI

private struct ColorThemeKey: EnvironmentKey {
    static let defaultValue: ColorTheme = ColorTheme.current
}

extension EnvironmentValues {
    public var colorTheme: ColorTheme {
        get { self[ColorThemeKey.self] }
        set { self[ColorThemeKey.self] = newValue }
    }
}
