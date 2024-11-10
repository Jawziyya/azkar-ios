import Entities

private let englishMapping = LanguageMapping(name: "English", mapping: { data in
    // Arabic letters
    switch data.characterType {
    case .harf(.ba): return "b"
    case .harf(.ta): return "t"
    case .harf(.taMarbuta): return "t"
    case .harf(.tha): return "th"
    case .harf(.jeem): return "j"
    case .harf(.hha): return "ḥ"
    case .harf(.kha): return "kh"
    case .harf(.dal): return "d"
    case .harf(.thal): return "dh"
    case .harf(.ra): return "r"
    case .harf(.zay): return "z"
    case .harf(.seen): return "s"
    case .harf(.sheen): return "sh"
    case .harf(.sad): return "ṣ"
    case .harf(.dad): return "ḍ"
    case .harf(.tah): return "ṭ"
    case .harf(.zah): return "ẓ"
    case .harf(.ain): return "ʿ"
    case .harf(.ghain): return "gh"
    case .harf(.fa): return "f"
    case .harf(.qaf): return "q"
    case .harf(.kaf): return "k"
    case .harf(.lam): return "l"
    case .harf(.meem): return "m"
    case .harf(.noon): return "n"
    case .harf(.ha): return "h"
    case .harf(.waw): return "w"
    case .harf(.ya): return "y"
        
    case .vowel(.u): return "u"
    case .vowel(.hamzaU): return "’u"
    case .vowel(.longU): return "ū"
    case .vowel(.tanweenDamma): return "un"
        
    case .vowel(.a): return "a"
    case .vowel(.hamzaA): return "’a"
    case .vowel(.longA): return "а̄"
    case .vowel(.tanweenFatha): return "an"
        
    case .vowel(.i): return "i"
    case .vowel(.hamzaI): return "’i"
    case .vowel(.longI): return "ī"
    case .vowel(.tanweenKasra): return "in"
        
    case .special(.space): return " "
    case .special(.hyphen): return "-"
        
    default: return ""
    }
})

private let russianMapping = LanguageMapping( name: "Russian", mapping: { data in
    switch data.characterType {
    case .harf(.ba): return "б"
    case .harf(.ta): return "т"
    case .harf(.taMarbuta): return "т"
    case .harf(.tha): return "с̱"
    case .harf(.jeem): return "дж"
    case .harf(.hha): return "х̣"
    case .harf(.kha): return "х"
    case .harf(.dal): return "д"
    case .harf(.thal): return "з̱"
    case .harf(.ra): return "р"
    case .harf(.zay): return "з"
    case .harf(.seen): return "с"
    case .harf(.sheen): return "ш"
    case .harf(.sad): return "с̣"
    case .harf(.dad): return "д̣"
    case .harf(.tah): return "т̣"
    case .harf(.zah): return "з̣"
    case .harf(.ain): return "ʿ"
    case .harf(.ghain): return "г̣"
    case .harf(.fa): return "ф"
    case .harf(.qaf): return "к̣"
    case .harf(.kaf): return "к"
    case .harf(.lam) where data.tashkeel == .sukun: return "ль"
    case .harf(.lam): return "л"
    case .harf(.meem): return "м"
    case .harf(.noon): return "н"
    case .harf(.ha): return "һ"
    case .harf(.waw): return "в"
    case .harf(.ya): return "й"
        
    case .vowel(.u): return "у"
    case .vowel(.hamzaU): return "’у"
    case .vowel(.longU): return "ӯ"
    case .vowel(.tanweenDamma): return "ун"
        
    case .vowel(.a): return "а"
    case .vowel(.hamzaA): return "’а"
    case .vowel(.longA): return "а̄"
    case .vowel(.tanweenFatha): return "ан"
        
    case .vowel(.i): return "и"
    case .vowel(.hamzaI): return "’и"
    case .vowel(.longI): return "ӣ"
    case .vowel(.tanweenKasra): return "ин"        
        
    case .special(.space): return " "
    case .special(.hyphen): return "-"
        
    default: return ""
    }
})

enum TranscriptorProvider {
    static func createTranscriptor(for language: Language) -> Transcriptor? {
        let mapping: LanguageMapping
        switch language {
        case .russian, .chechen, .ingush, .kazakh, .kyrgyz, .uzbek: mapping = russianMapping
        case .english: mapping = englishMapping
        case .arabic, .turkish, .georgian: return nil
        }
        return Transcriptor(mapping: mapping)
    }
}
