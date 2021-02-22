//
//  MarkdownProcessor.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftyMarkdown
import UIKit
import SwiftUI

enum MarkdownProcessor {

    static func arabicText(_ text: String, textStyle: UIFont.TextStyle = .body, fontName: String?, alignment: NSTextAlignment = .right, sizeCategory: ContentSizeCategory? = nil) -> NSAttributedString {
        let md = SwiftyMarkdown(string: text)
        let size = textSize(forTextStyle: textStyle, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        let fontName = fontName ?? ArabicFont.adobe.fontName
        md.setFontNameForAllStyles(with: fontName)
        md.setFontSizeForAllStyles(with: size)
        md.body.alignment = alignment
        md.body.color = UIColor(Color.text).withAlphaComponent(0.6)
        md.bold.color = UIColor(Color.text)
        let attributedString = md.attributedString().mutableCopy() as! NSMutableAttributedString

        let string = attributedString.string
        let regex = try! NSRegularExpression(pattern: "،", options: [])
        let range = NSRange(string.range(of: string)!, in: string)
        regex.enumerateMatches(in: string, options: .reportProgress, range: range) { (result, _, _) in
            if let range = result?.range {
                attributedString.addAttribute(.font, value: UIFont(name: ArabicFont.adobe.fontName, size: size)!, range: range)
            }
        }

        return attributedString
    }

    static func translationText(_ text: String, alignment: NSTextAlignment = .natural, sizeCategory: ContentSizeCategory? = nil) -> NSAttributedString {
        let md = SwiftyMarkdown(string: text)
        let textStyle = UIFont.TextStyle.body
        let size = textSize(forTextStyle: textStyle, contentSizeCategory: sizeCategory?.uiContentSizeCategory)
        md.setFontSizeForAllStyles(with: size)

        let fontName = UIFont.FontFamily.iowan.fontName(with: .regular)
        md.body.fontName = fontName
        md.body.alignment = alignment
        return md.attributedString()
    }

}
