import SwiftUI

private extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 28
        case .title2: return 22
        case .title3: return 20
        case .headline: return 17
        case .body: return 17
        case .callout: return 16
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 17
        }
    }
}

/// A view modifier that applies the font design of the current color theme.
public struct FontDesignModifier: ViewModifier {
    
    public enum FontSizeType {
        case size(CGFloat), style(Font.TextStyle)
    }
    
    public struct FontModification: OptionSet {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        public static let none = FontModification(rawValue: 0 << 0)
        public static let smallCaps = FontModification(rawValue: 1 << 0)
        public static let lowercaseSmallCaps = FontModification(rawValue: 1 << 1)
        public static let uppercaseSmallCaps = FontModification(rawValue: 1 << 2)
        public static let italic = FontModification(rawValue: 1 << 3)
    }
    
    @Environment(\.appTheme) var appTheme
    
    let fontSizeType: FontSizeType
    let fontWeight: Font.Weight?
    let fontModification: FontModification
    
    public func body(content: Content) -> some View {
        content.font(modifiedFont)
    }
    
    var modifiedFont: Font {
        var font = self.font
        if fontModification.contains(.italic) {
            font = font.italic()
        }
        if fontModification.contains(.smallCaps) {
            font = font.smallCaps()
        }
        if fontModification.contains(.lowercaseSmallCaps) {
            font = font.lowercaseSmallCaps()
        }
        if fontModification.contains(.uppercaseSmallCaps) {
            font = font.uppercaseSmallCaps()
        }
        if let fontWeight {
            return font.weight(fontWeight)
        } else {
            return font
        }
    }
    
    var font: Font {
        let customFontName = appTheme.font
        
        switch fontSizeType {
        case .size(let size):
            if let customFontName {
                return Font.custom(customFontName, fixedSize: size)
            } else {
                return Font.system(size: size, weight: .regular, design: appTheme.fontDesign)
            }
        case .style(let style):
            if let customFontName {
                return Font.custom(customFontName, size: style.size, relativeTo: style)
            } else {
                return Font.system(style, design: appTheme.fontDesign)
            }
        }
    }
    
}

extension View {
    /// Applies the font design of the current color theme to the view.
    public func systemFont(
        _ size: CGFloat,
        weight: Font.Weight? = nil,
        modification: FontDesignModifier.FontModification = .none
    ) -> some View {
        modifier(FontDesignModifier(
            fontSizeType: .size(size),
            fontWeight: weight,
            fontModification: modification
        ))
    }
    
    /// Applies the font design of the current color theme to the view.
    public func systemFont(
        _ style: Font.TextStyle,
        weight: Font.Weight? = nil,
        modification: FontDesignModifier.FontModification = .none
    ) -> some View {
        modifier(FontDesignModifier(
            fontSizeType: .style(style),
            fontWeight: weight,
            fontModification: modification
        ))
    }
}
