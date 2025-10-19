import Foundation

public struct ShareTextProvider {
    
    let zikr: Zikr
    let translation: [String]
    let transliteration: [String]
    let includeTitle: Bool
    let includeTranslation: Bool
    let includeTransliteration: Bool
    let includeBenefits: Bool
    let enableLineBreaks: Bool
    
    func getShareText() -> String {
        var text = ""
        
        if includeTitle, let title = zikr.title {
            text += title + "\n\n"
        }
        
        text += enableLineBreaks
            ? zikr.text
            : zikr.text
                .components(separatedBy: "\n")
                .joined(separator: " ")
        
        if includeTranslation, !translation.isEmpty {
            let translationText = enableLineBreaks
                ? translation.joined(separator: "\n")
                : translation.joined(separator: " ")
            text += "\n\n\(translationText)"
        }
        
        if includeTransliteration, !transliteration.isEmpty {
            let transliterationText = enableLineBreaks
                ? transliteration.joined(separator: "\n")
                : transliteration.joined(separator: " ")
            text += "\n\n\(transliterationText)"
        }
        
        text += "\n\n\(zikr.source)"
        
        if includeBenefits, let benefits = zikr.benefits {
            text += "\n\n💎 \(benefits)"
        }
        
        return text
    }
    
}
