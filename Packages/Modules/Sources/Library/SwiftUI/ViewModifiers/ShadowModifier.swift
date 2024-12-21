import SwiftUI

public struct ShadowModifier: ViewModifier {
    @Environment(\.colorTheme) private var colorTheme
    
    public func body(content: Content) -> some View {
        if let shadowStyle = colorTheme.shadowStyle {
            content
                .shadow(
                    color: shadowStyle.color,
                    radius: shadowStyle.radius,
                    x: shadowStyle.offset.x,
                    y: shadowStyle.offset.y
                )
        } else {
            content
        }
    }
    
}

public extension View {
    /// Applies a rounded border based on the current color theme.
    func applyShadow() -> some View {
        self.modifier(ShadowModifier())
    }
}
