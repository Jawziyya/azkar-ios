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

public extension String {
    func extractContext(_ query: String, contextWords: Int = 10) -> [String] {
        // Define the regex pattern to find the query with one or two words before and after, case insensitive
        let wordsPattern = "(?:\\S+\\s)?"
        let pattern = "\(String(repeating: wordsPattern, count: contextWords))\\S*\(NSRegularExpression.escapedPattern(for: query))\\S*(?:\\s\\S+)?\(String(repeating: wordsPattern, count: contextWords))"


        // Compile the regular expression
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else { return [] }
        
        // Find matches in the given text
        let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
        
        // Extract the matching strings and format them with ellipses
        return matches.compactMap { match -> String? in
            guard
                let range = Range(match.range, in: self),
                range.lowerBound >= self.startIndex,
                range.upperBound <= self.endIndex
            else {
                return nil
            }
            
            var matchText = String(self[range]).replacingOccurrences(of: "\n", with: " ")
            // Check if the match is not at the start of the text and prepend ellipsis if needed
            if range.lowerBound != self.startIndex {
                matchText = "... \(matchText)"
            }
            
            // Check if the match is not at the end of the text and append ellipsis if needed
            if range.upperBound != self.endIndex {
                matchText = "\(matchText) ..."
            }
            
            return matchText
        }
    }

}
