// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

/// Represents content language
/// .rawValue is ISO 639-1 identifier.
public enum LangId: String, Codable {
    case arabic = "ar"
    case turkish = "tr"
    case english = "en"
    case russian = "ru"
    case georgian = "ka"
    case chechen = "che"
    case ingush = "inh"
    
    /// ISO 639-1 identifier
    public var id: String {
        rawValue
    }
    
    /// Non-localized language title.
    public var title: String {
        switch self {
        case .arabic:
            return "اللغة العربية"
        case .turkish:
            return "Türk dili"
        case .russian:
            return "Русский язык"
        case .english:
            return "English language"
        case .georgian:
            return "ქართული ენა"
        case .chechen:
            return "Нохчийн мотт"
        case .ingush:
            return "Гӏалгӏай мотт"
        }
    }
}

public extension LangId {
    static func getSystemLanguage() -> LangId {
        let code: String
        if let preffedLocalizationCode = Bundle.main.preferredLocalizations.first?.components(separatedBy: "-").first {
            code = preffedLocalizationCode
        } else {
            code = Locale.current.languageCode ?? "en"
        }
        let id = String(code.lowercased().prefix(2))
        return LangId(rawValue: id) ?? .english
    }
}
