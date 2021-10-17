//
//
//  Azkar
//  
//  Created on 22.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation

var languageIdentifier: String {
    Locale.preferredLanguages[0]
}

struct Fadl: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case _source = "source", sourceExtension = "source_ext"
        case _text = "text", textEn = "text_en", textAr = "text_ar"
    }
    
    let id: Int
    private let _text: String
    private let textEn: String?
    private let textAr: String?
    private let _source: String
    private let sourceExtension: String?
    
    var text: String {
        switch languageIdentifier {
        case "ru": return _text
        case "ar": return textAr ?? _text
        default: return textEn ?? _text
        }
    }
    
    var source: String {
        var source = NSLocalizedString("text.source." + _source, comment: "")
        if let ext = sourceExtension {
            source += ", " + ext
        }
        return source
    }

    static var all: [Fadl] = {
        let url = Bundle.main.url(forResource: "fudul", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode([Fadl].self, from: data)
    }()
}
