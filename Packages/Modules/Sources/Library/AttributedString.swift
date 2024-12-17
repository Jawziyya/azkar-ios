import SwiftUI

public func attributedString(_ text: String, highlighting pattern: String? = nil) -> AttributedString {
    var attributedString = (try? AttributedString(markdown: text)) ?? AttributedString(text)
    
    if let pattern = pattern {
        var currentSearchRange = attributedString.startIndex..<attributedString.endIndex
        while let range = attributedString[currentSearchRange].range(of: pattern, options: [.caseInsensitive, .diacriticInsensitive]) {
            let globalRange = range.lowerBound..<range.upperBound
            attributedString[globalRange].backgroundColor = UIColor.systemBlue.withAlphaComponent(0.25)
            
            if globalRange.upperBound < attributedString.endIndex {
                currentSearchRange = globalRange.upperBound..<attributedString.endIndex
            } else {
                break
            }
        }
    }

    return attributedString
}
