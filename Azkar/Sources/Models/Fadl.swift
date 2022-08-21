//
//
//  Azkar
//  
//  Created on 22.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation

struct Fadl: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _source = "source", sourceExtension = "source_ext"
        case _text = "text", textRu = "text_ru", textAr = "text_ar"
    }
    
    let id: Int
    private let _text: String
    private let textRu: String?
    private let textAr: String?
    private let _source: String
    private let sourceExtension: String?
    
    var text: String {
        switch languageIdentifier {
        case .ru: return textRu ?? _text
        case .ar: return textAr ?? _text
        default: return _text
        }
    }
    
    var source: String {
        var source = NSLocalizedString("text.source." + _source.lowercased(), comment: "")
        if let ext = sourceExtension {
            source += ", " + ext
        }
        return source
    }
    
}
