import SwiftUI
import Extensions

public struct RoundedBorderModifier: ViewModifier {
    
    @Environment(\.appTheme) private var appTheme
     
    let roundingCorners: UIRectCorner
    let borderColor: Color?
    
    public func body(content: Content) -> some View {
        if let borderStyle = appTheme.borderStyle {
            content
                .clipShape(roundingShape)
                .overlay(
                    roundingShape
                        .stroke(borderColor ?? borderStyle.color, lineWidth: borderStyle.width)
                )
        } else {
            content.clipShape(roundingShape)
        }
    }
    
    private var roundingShape: some Shape {
        RoundedCornersShape(radius: appTheme.cornerRadius, corners: roundingCorners)
    }
    
}

public extension View {
    /// Applies a rounded border based on the current color theme.
    func roundedBorder(
        _ corners: UIRectCorner = .allCorners,
        color: Color? = nil
    ) -> some View {
        self.modifier(RoundedBorderModifier(
            roundingCorners: corners,
            borderColor: color
        ))
    }
}
