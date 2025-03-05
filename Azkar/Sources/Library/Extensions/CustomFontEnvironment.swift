//  Copyright © 2023 Al Jawziyya. All rights reserved.

import SwiftUI
import Library

// Custom environment key for font
struct CustomTranslationFontKey: EnvironmentKey {
    static let defaultValue = TranslationFont.systemFont
}

struct CustomArabicFont: EnvironmentKey {
    static let defaultValue = ArabicFont.systemArabic
}

// Environment value extension
extension EnvironmentValues {
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
    let style: UIFont.TextStyle
    let isArabic: Bool
    
    func body(content: Content) -> some View {
        let font: AppFont = isArabic ? arabicFont : translationFont
        let effectiveSizeCategory = fontSizeCategory?.uiContentSizeCategory ?? sizeCategory.uiContentSizeCategory
        let size = textSize(forTextStyle: style, contentSizeCategory: effectiveSizeCategory)
        let named = font.postscriptName
        let adjustment = CGFloat(font.sizeAdjustment ?? 0)
        return content.font(.custom(named, fixedSize: size + adjustment))
    }
}

extension View {
    func customFont(_ style: UIFont.TextStyle = .body, isArabic: Bool = false) -> some View {
        modifier(CustomFontStyleModifier(style: style, isArabic: isArabic))
    }
}
