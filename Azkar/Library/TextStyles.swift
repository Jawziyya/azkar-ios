//
//  TextStyles.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftRichString

enum TextStyles {

    static func arabicTextStyle(fontName: String? = nil, textStyle: UIFont.TextStyle = .body, alignment: NSTextAlignment = .right, sizeCategory: ContentSizeCategory? = nil) -> StyleProtocol {
        let size = textSize(forTextStyle: textStyle, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        let style = Style {
            $0.font = UIFont(name: fontName ?? ArabicFont.noto.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
            $0.lineHeightMultiple = 1.1
            $0.alignment = alignment
        }

        if fontName == ArabicFont.KFGQP.fontName {
            let regexStyle = StyleRegEx(base: style, pattern: "،", options: []) {
                $0.font = UIFont(name: ArabicFont.adobe.fontName, size: size)
            }
            return regexStyle ?? style
        } else {
            return style
        }
    }

    static func bodyStyle(maxSize: CGFloat? = nil, type: UIFont.FontType = .regular, sizeCategory: ContentSizeCategory? = nil) -> StyleProtocol {
        return Style {
            $0.font = UIFont.textFont(for: .body, maxSize: maxSize, type: type, sizeCategory: sizeCategory?.uiContentSizeCategory)
            $0.lineHeightMultiple = 1.2
            $0.kerning = .point(0.5)
            $0.hyphenationFactor = 1.0
        }
    }

}
