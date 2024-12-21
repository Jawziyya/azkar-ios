import SwiftUI

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
    
    @Environment(\.colorTheme) var colorTheme
    
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
        switch fontSizeType {
        case .size(let size):
            return Font.system(size: size, weight: .regular, design: colorTheme.fontDesign)
        case .style(let style):
            return Font.system(style, design: colorTheme.fontDesign)
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
