//
//  TextStyles.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import BonMot
import SwiftUI

enum TextStyles {

    static func arabicTextStyle(fontName: String? = nil, textStyle: UIFont.TextStyle = .body, alignment: NSTextAlignment = .right, sizeCategory: ContentSizeCategory? = nil) -> StringStyle {
        let size = textSize(forTextStyle: textStyle, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        let font = UIFont(name: fontName ?? ArabicFont.noto.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        return StringStyle(
            .font(font),
            .lineHeightMultiple(1.1),
            .alignment(alignment)
        )
    }

    static func bodyStyle(maxSize: CGFloat? = nil, type: UIFont.FontType = .regular, sizeCategory: ContentSizeCategory? = nil) -> StringStyle {
        return StringStyle(
            .font(UIFont.textFont(for: .body, maxSize: maxSize, type: type, sizeCategory: sizeCategory?.uiContentSizeCategory)),
            .lineHeightMultiple(1.2),
            .tracking(Tracking.point(0.5)),
            .hyphenationFactor(1.0)
        )
    }

}
