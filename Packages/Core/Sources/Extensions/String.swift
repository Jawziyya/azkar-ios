//
//  String.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import SwiftUI

var arabicVowelsPattern: String {
    return "[\\u064B-\\u0650]|[\\u065D-\\u065E]|\\u0657|[\\u0618-\\u061A]"
}

extension String: Identifiable {
    public var id: String {
        return self
    }
}

public extension String {

    var nsRange: NSRange {
      return NSRange(range(of: self)!, in: self)
    }

    var textOrNil: String? {
        let text = trimmingCharacters(in: .whitespacesAndNewlines)
        return text.isEmpty ? nil : text
    }

    func firstWord() -> Self {
        return self.components(separatedBy: ",").first ?? self
    }

    /// Returns a new string without any arabic vowels (tashkeel) in
    var trimmingArabicVowels: String {
      let arabicVowelsRange = UnicodeScalar(1611)!...UnicodeScalar(1630)!
      let arabicVowelsSet = CharacterSet(charactersIn: arabicVowelsRange)
        .subtracting(CharacterSet(charactersIn: "ّ"))
      return components(separatedBy: arabicVowelsSet).joined()
    }
}

public extension String {

    func imageWith(font: UIFont, color: UIColor, size: CGSize) -> UIImage? {
        let nsstring = (self as NSString)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let stringSize = nsstring.size(withAttributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let origin = CGPoint(x: size.width/2 - stringSize.width/2, y: size.height/2 - stringSize.height/2)
        nsstring.draw(in: .init(origin: origin, size: stringSize), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
