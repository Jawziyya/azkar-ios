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
        case textRu = "text_ru", textEn = "text_en"
    }
    
    let id: Int
    private let textRu: String?
    private let textEn: String?
    private let _source: String
    private let sourceExtension: String?
    
    var text: String? {
        switch languageIdentifier {
        case .ru: return textRu
        case .en: return textEn
        default: return nil
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
