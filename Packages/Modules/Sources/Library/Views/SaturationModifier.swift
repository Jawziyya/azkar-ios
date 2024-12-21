import SwiftUI

public struct SaturationModifier: ViewModifier {
    
    @Environment(\.colorTheme) var colorTheme
    
    public init() {}
    
    public func body(content: Content) -> some View {
        content.saturation(colorTheme.isBlackWhite ? 0.1 : 1)
    }
    
}

extension View {
    /// Removes saturation from the view if the color theme is Black & White.
    public func removeSaturationIfNeeded() -> some View {
        self.modifier(SaturationModifier())
    }
}
