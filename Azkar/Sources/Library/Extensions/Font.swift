//
//  Font.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Library

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFontStyle: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var style: UIFont.TextStyle

    func body(content: Content) -> some View {
        let size = textSize(forTextStyle: style, contentSizeCategory: sizeCategory.uiContentSizeCategory)
        return content.font(.custom(name, size: size))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
    
    func scaledFont(name: String, style: UIFont.TextStyle) -> some View {
        return self.modifier(ScaledFontStyle(name: name, style: style))
    }
}

func textSize(forTextStyle textStyle: UIFont.TextStyle, contentSizeCategory: UIContentSizeCategory? = nil) -> CGFloat {
    if let sizeCategory = contentSizeCategory {
        return UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle, compatibleWith: .init(preferredContentSizeCategory: sizeCategory)).pointSize
    }
    return UIFont.preferredFont(forTextStyle: textStyle).pointSize
}

extension Font {
    
    static func customFont(_ font: AppFont, style: UIFont.TextStyle = .body, sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory, fixedSize: Bool = !Preferences.shared.useSystemFontSize) -> Font {
        let size = textSize(forTextStyle: style, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        let named = font.postscriptName
        let adjustment = CGFloat(font.sizeAdjustment ?? 0)
        if fixedSize {
            return Font.custom(named, fixedSize: size + adjustment)
        } else {
            return Font.custom(named, size: size + adjustment)
        }
    }
    
    static func customFont(_ named: String, style: UIFont.TextStyle = .body, sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory) -> Font {
        let size = textSize(forTextStyle: style, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        if Preferences.shared.useSystemFontSize || sizeCategory == nil {
            return Font.custom(named, size: size)
        } else {
            return Font.custom(named, fixedSize: size)
        }
    }
    
}
