//
//  TextStyles.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import BonMot

enum TextStyles {

    static func arabicTextStyle(fontName: String? = nil, textStyle: UIFont.TextStyle = .body, alignment: NSTextAlignment = .right) -> StringStyle {
        let size = textSize(forTextStyle: textStyle)
        let font = UIFont(name: fontName ?? ArabicFont.amiri.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        return StringStyle(
            .font(font),
            .lineHeightMultiple(1.1),
            .alignment(alignment)
        )
    }

    static func bodyStyle(maxSize: CGFloat? = nil, type: UIFont.FontType = .regular) -> StringStyle {
        return StringStyle(
            .font(UIFont.textFont(for: .body, maxSize: maxSize, type: type)),
            .lineHeightMultiple(1.2),
            .tracking(Tracking.point(0.5)),
            .hyphenationFactor(1.0)
        )
    }

}
