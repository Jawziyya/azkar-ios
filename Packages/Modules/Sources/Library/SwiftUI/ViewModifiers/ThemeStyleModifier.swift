import SwiftUI

public struct ThemeStyleModifier: ViewModifier {
    
    @Environment(\.appTheme) private var appTheme
    @Environment(\.colorTheme) private var colorTheme
    
    var indexPosition: IndexPosition?
    let roundingCorners: UIRectCorner
    
    public func body(content: Content) -> some View {
        switch appTheme {
        case .flat:
            applyFlatStyle(content)
        case .neomorphic:
            applyNeomorphicStyle(content)
        default:
            content.roundedBorder(roundingCorners)
        }
    }
    
    func applyFlatStyle(_ content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .stroke(colorTheme.getColor(.accent), lineWidth: 1.5)
            )
            .background(
                Color.getColor(.text, theme: colorTheme)
                    .offset(x: 5, y: 5)
            )
    }
    
    @ViewBuilder func applyNeomorphicStyle(_ content: Content) -> some View {
        if let indexPosition {
            if indexPosition == .first {
                content
                    .roundedBorder(roundingCorners)
                    .applyTopNeomorphicShadow(radius: 3)
            } else if indexPosition == .other {
                content.roundedBorder(roundingCorners)
            } else if indexPosition == .last {
                content
                    .roundedBorder(roundingCorners)
                    .applyBottomNeomorphicShadow(radius: 3)
            }
        } else {
            content
                .roundedBorder(roundingCorners)
                .applyTopNeomorphicShadow()
                .applyBottomNeomorphicShadow()
        }
    }
    
}

private extension View {
    func applyTopNeomorphicShadow(radius: CGFloat = 12) -> some View {
        self.shadow(color: Color.white.opacity(0.6), radius: radius, x: -4, y: -4)
    }
    
    func applyBottomNeomorphicShadow(radius: CGFloat = 10) -> some View {
        self.shadow(color: Color(hex: "808080").opacity(0.5), radius: radius, x: 5, y: 5)
    }
}

public extension View {
    /// Applies a rounded border based on the current color theme.
    func applyTheme(
        indexPosition: IndexPosition? = nil,
        roundingCorners: UIRectCorner = .allCorners
    ) -> some View {
        self.modifier(ThemeStyleModifier(
            indexPosition: indexPosition,
            roundingCorners: roundingCorners
        ))
    }
    
    func applyTheme(
        indexPosition: IndexPosition
    ) -> some View {
        self.applyTheme(
            indexPosition: indexPosition,
            roundingCorners: {
                switch indexPosition {
                case .first:
                    return [.topLeft, .topRight]
                case .last:
                    return [.bottomLeft, .bottomRight]
                case .only:
                    return .allCorners
                case .other:
                    return []
                }
            }()
        )
    }
    
    func applyContainerStyle(
        roundingCorners: UIRectCorner = .allCorners
    ) -> some View {
        self
            .padding()
            .background(.contentBackground)
            .applyTheme(roundingCorners: roundingCorners)
            .padding()
            .reloadWhenThemeChanges()
    }
    
    /// Reloads the view when the theme changes
    func reloadWhenThemeChanges() -> some View {
        self.modifier(ThemeReloadModifier())
    }
}

/// A modifier that forces view reload when theme changes
fileprivate struct ThemeReloadModifier: ViewModifier {
    @Environment(\.appTheme) private var appTheme
    @Environment(\.colorTheme) private var colorTheme
    
    func body(content: Content) -> some View {
        content.id("theme-\(appTheme)-\(colorTheme)")
    }
}
