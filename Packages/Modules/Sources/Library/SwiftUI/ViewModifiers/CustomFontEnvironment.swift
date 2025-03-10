//  Copyright © 2023 Al Jawziyya. All rights reserved.

import SwiftUI

// Custom environment key for font
public struct CustomTranslationFontKey: EnvironmentKey {
    public static let defaultValue = TranslationFont.systemFont
}

public struct CustomArabicFont: EnvironmentKey {
    public static let defaultValue = ArabicFont.systemArabic
}

// Environment value extension
public extension EnvironmentValues {
    var translationFont: TranslationFont {
        get { self[CustomTranslationFontKey.self] }
        set { self[CustomTranslationFontKey.self] = newValue }
    }
    
    var arabicFont: ArabicFont {
        get { self[CustomArabicFont.self] }
        set { self[CustomArabicFont.self] = newValue }
    }
}

struct CustomFontStyleModifier: ViewModifier {
    @Environment(\.translationFont) var translationFont
    @Environment(\.arabicFont) var arabicFont
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.fontSizeCategory) var fontSizeCategory
    
    enum SizeSpecifier {
        case style(UIFont.TextStyle)
        case size(CGFloat)
    }
    
    let size: SizeSpecifier
    let isArabic: Bool
    
    func body(content: Content) -> some View {
        let font: AppFont = isArabic ? arabicFont : translationFont
        let effectiveSizeCategory = fontSizeCategory?.uiContentSizeCategory ?? sizeCategory.uiContentSizeCategory
        let fontSize: CGFloat
        switch size {
        case let .style(style):
            fontSize = textSize(forTextStyle: style, contentSizeCategory: effectiveSizeCategory)
        case let .size(customSize):
            fontSize = customSize
        }
        let named = font.postscriptName
        let adjustment = CGFloat(font.sizeAdjustment ?? 0)
        return content.font(.custom(named, fixedSize: fontSize + adjustment))
    }
}

public extension View {
    func customFont(_ style: UIFont.TextStyle = .body, isArabic: Bool = false) -> some View {
        modifier(CustomFontStyleModifier(size: .style(style), isArabic: isArabic))
    }
    
    func customFont(size: CGFloat, isArabic: Bool = false) -> some View {
        modifier(CustomFontStyleModifier(size: .size(size), isArabic: isArabic))
    }
}
