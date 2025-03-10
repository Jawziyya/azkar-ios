import Foundation

public struct ShareTextProvider {
    
    let zikr: Zikr
    let translation: [String]
    let transliteration: [String]
    let includeTitle: Bool
    let includeTranslation: Bool
    let includeTransliteration: Bool
    let includeBenefits: Bool
    
    func getShareText() -> String {
        var text = ""
        
        if includeTitle, let title = zikr.title {
            text += title + "\n\n"
        }
        
        text += zikr.text
            .components(separatedBy: "\n")
            .joined(separator: " ")
        
        if includeTranslation, !translation.isEmpty {
            text += "\n\n\(translation.joined(separator: " "))"
        }
        
        if includeTransliteration, !transliteration.isEmpty {
            text += "\n\n\(transliteration.joined(separator: " "))"
        }
        
        text += "\n\n\(zikr.source)"
        
        if includeBenefits, let benefits = zikr.benefits {
            text += "\n\n💎 \(benefits)"
        }
        
        return text
    }
    
}
