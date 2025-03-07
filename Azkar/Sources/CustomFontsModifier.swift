import SwiftUI
import Library

/// A view modifier that injects the appTheme from Preferences into the environment
private struct CustomFontsModifier: ViewModifier {
    @ObservedObject private var preferences: Preferences = .shared
    
    func body(content: Content) -> some View {
        content
            .environment(\.arabicFont, preferences.preferredArabicFont)
            .environment(\.translationFont, preferences.preferredTranslationFont)
    }
}

public extension View {
    /// Connects the color theme from Preferences to the environment
    func connectCustomFonts() -> some View {
        self.modifier(CustomFontsModifier())
    }
}
