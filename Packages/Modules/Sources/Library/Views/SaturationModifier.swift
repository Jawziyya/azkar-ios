import SwiftUI

public struct SaturationModifier: ViewModifier {
    public init() {}
    public func body(content: Content) -> some View {
        content
            .saturation(ColorTheme.current == .ink ? 0 : 1)
    }
}

// Extension to make it easier to apply the modifier
extension View {
    public func removeSaturationIfNeeded() -> some View {
        self.modifier(SaturationModifier())
    }
}
