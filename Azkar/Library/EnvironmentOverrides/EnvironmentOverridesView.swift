import SwiftUI

extension EnvironmentValues {
    struct Diff: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let colorScheme = Diff(rawValue: 1 << 1)
        public static let sizeCategory = Diff(rawValue: 1 << 2)
    }
}

extension View {
    func attachEnvironmentOverrides(preferences: Preferences, onChange: ((EnvironmentValues.Diff) -> Void)? = nil) -> some View {
        modifier(EnvironmentOverridesModifier(preferences: preferences, onChange: onChange))
    }
}

struct EnvironmentOverridesModifier: ViewModifier {

    @ObservedObject var preferences: Preferences

    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    let onChange: ((EnvironmentValues.Diff) -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear { self.copyDefaultSettings() }
            .environment(\.sizeCategory, preferences.useSystemFontSize ? defaultSizeCategory : preferences.sizeCategory)
    }
    
    private func copyDefaultSettings() {
        if preferences.useSystemFontSize {
            preferences.sizeCategory = defaultSizeCategory
        }
    }
    
}
