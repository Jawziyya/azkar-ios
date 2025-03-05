import SwiftUI

/// A view modifier that injects the appTheme from Preferences into the environment
private struct AppThemeModifier: ViewModifier {
    @ObservedObject private var preferences: Preferences = .shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.appTheme, preferences.appTheme)
            .environment(\.colorTheme, preferences.colorTheme)
            .tint(Color.accent)
    }
}

public extension View {
    /// Connects the color theme from Preferences to the environment
    func connectAppTheme() -> some View {
        self.modifier(AppThemeModifier())
    }
}
