//
//  Hadith.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation

struct Hadith: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id, text
        case _translation = "translation"
        case translationEN = "translation_en"
        case translationTR = "translation_tr"
        case _source = "source"
        case sourceExtension = "source_ext"
    }
    
    let id: Int
    let text: String
    private let _translation: String?
    private let translationEN: String?
    private let translationTR: String?
    private let _source: String
    private let sourceExtension: String?
    
    var translation: String? {
        switch languageIdentifier {
        case .ar: return nil
        case .ru: return _translation
        case .tr: return translationTR
        default: return translationEN
        }
    }
    
    var source: String {
        var source = NSLocalizedString("text.source." + _source.lowercased(), comment: "")
        if let ext = sourceExtension {
            source += ", " + ext
        }
        return source
    }

    static var placeholder: Hadith {
        Hadith(id: 1, text: "Text", _translation: "Translatioin", translationEN: "Translation EN", translationTR: "Translation TR", _source: "Source", sourceExtension: "123")
    }

}
