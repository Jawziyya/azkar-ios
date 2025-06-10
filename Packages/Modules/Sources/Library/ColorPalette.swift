import SwiftUI
import AzkarResources

struct ThemeAwareColorModifier: ViewModifier {
    @Environment(\.colorTheme) var theme
    private let colorType: ColorType
    private let opacity: Double

    init(colorType: ColorType, opacity: Double = 1.0) {
        self.colorType = colorType
        self.opacity = opacity
    }

    func body(content: Content) -> some View {
        let color = Color.getColor(colorType.rawValue, theme: theme)
        return content.foregroundColor(color.opacity(opacity))
    }
}

struct ThemeAwareBackgroundModifier: ViewModifier, ShapeStyle {
    @Environment(\.colorTheme) var theme
    let colorType: ColorType
    let opacity: Double
    let ignoreSafeArea: IgnoreSafeAreaInfo?

    func body(content: Content) -> some View {
        let color = Color.getColor(colorType.rawValue, theme: theme)
        if let ignoreSafeArea {
            content.background(color.opacity(opacity).ignoresSafeArea(ignoreSafeArea.regions, edges: ignoreSafeArea.edges))
        } else {
            content.background(color.opacity(opacity))
        }
    }
}

public struct IgnoreSafeAreaInfo {
    public let regions: SafeAreaRegions
    public let edges: Edge.Set
    
    public init(regions: SafeAreaRegions = .all, edges: Edge.Set = .all) {
        self.regions = regions
        self.edges = edges
    }
    
    public static let all = IgnoreSafeAreaInfo()
}

public extension View {
    func foregroundStyle(_ colorType: ColorType, opacity: Double = 1.0) -> some View {
        self.modifier(ThemeAwareColorModifier(colorType: colorType, opacity: opacity))
    }
    
    @ViewBuilder
    func background(
        _ colorType: ColorType,
        opacity: Double = 1.0,
        ignoreSafeArea: IgnoreSafeAreaInfo? = nil
    ) -> some View {
        modifier(
            ThemeAwareBackgroundModifier(
                colorType: colorType,
                opacity: opacity,
                ignoreSafeArea: ignoreSafeArea
            )
        )
    }
}

public enum ColorType: String {
    case accent, liteAccent, text, secondaryText, tertiaryText, background, contentBackground, secondaryBackground, dimmedBackground
}

public extension Color {
    
    static func getColor(_ type: ColorType, theme: ColorTheme? = nil) -> Color {
        return getColor(type.rawValue, theme: theme)
    }
    
    static func getColor(_ name: String = #function, theme: ColorTheme? = nil) -> Color {
        let colorTheme = theme ?? ColorTheme.current
        if let color = UIColor(named: colorTheme.assetsNamespace + name, in: azkarResourcesBundle, compatibleWith: nil) {
            return Color(color)
        } else {
            return Color(name, bundle: azkarResourcesBundle)
        }
    }
    
}
