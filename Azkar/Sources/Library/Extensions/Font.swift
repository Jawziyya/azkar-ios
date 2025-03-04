//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Library

// Custom environment key for font size category
struct FontSizeCategoryKey: EnvironmentKey {
    static let defaultValue: ContentSizeCategory? = nil
}

// Environment value extension
extension EnvironmentValues {
    var fontSizeCategory: ContentSizeCategory? {
        get { self[FontSizeCategoryKey.self] }
        set { self[FontSizeCategoryKey.self] = newValue }
    }
}

struct CustomFontModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.fontSizeCategory) var fontSizeCategory
    var font: AppFont
    var style: UIFont.TextStyle
    
    func body(content: Content) -> some View {
        let effectiveSizeCategory = fontSizeCategory?.uiContentSizeCategory ?? sizeCategory.uiContentSizeCategory
        let size = textSize(forTextStyle: style, contentSizeCategory: effectiveSizeCategory)
        let named = font.postscriptName
        let adjustment = CGFloat(font.sizeAdjustment ?? 0)
        return content.font(.custom(named, fixedSize: size + adjustment))
    }
}

struct CustomNamedFontModifier: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.fontSizeCategory) var fontSizeCategory
    var named: String
    var style: UIFont.TextStyle
    
    func body(content: Content) -> some View {
        let effectiveSizeCategory = fontSizeCategory?.uiContentSizeCategory ?? sizeCategory.uiContentSizeCategory
        let size = textSize(forTextStyle: style, contentSizeCategory: effectiveSizeCategory)
        return content.font(.custom(named, fixedSize: size))
    }
}

extension View {
    func customFont(_ font: AppFont, style: UIFont.TextStyle = .body) -> some View {
        self.modifier(CustomFontModifier(font: font, style: style))
    }
    
    func customFont(_ named: String, style: UIFont.TextStyle = .body) -> some View {
        self.modifier(CustomNamedFontModifier(named: named, style: style))
    }
    
    // Add a modifier to set the custom font size category
    func fontSizeCategory(_ category: ContentSizeCategory?) -> some View {
        self.environment(\.fontSizeCategory, category)
    }
}

func textSize(forTextStyle textStyle: UIFont.TextStyle, contentSizeCategory: UIContentSizeCategory? = nil) -> CGFloat {
    if let sizeCategory = contentSizeCategory {
        return UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: .init(preferredContentSizeCategory: sizeCategory)).pointSize
    }
    return UIFont.preferredFont(forTextStyle: textStyle).pointSize
}
