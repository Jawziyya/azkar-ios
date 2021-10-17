//
//  Zikr.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import Foundation
import AVFoundation

enum ZikrCategory: String, Codable, Equatable {
    case morning, evening, afterSalah = "after-salah", other

    var title: String {
        return NSLocalizedString("category." + rawValue, comment: "")
    }
}

struct Zikr: Identifiable, Hashable, Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, hadith
        case text, category, repeats
        
        case audioFileName = "audio_file_name"
        case rowInCategory = "row_in_category"
        
        case transliterationEN = "transliteration_en"
        case transliterationRU = "transliteration_ru"
        case transliterationTR = "transliteration_tr"
        
        case _title = "title"
        case titleRU = "title_ru"
        case titleEN = "title_en"
        case titleTR = "title_tr"
        
        case translationRU = "translation_ru"
        case translationEN = "translation_en"
        case translationTR = "translation_tr"
        
        case _notes = "notes"
        case notesRU = "notes_ru"
        case notesEN = "notes_en"
        case notesTR = "notes_tr"
        
        case _benefit = "benefit"
        case benefitRU = "benefit_ru"
        case benefitEN = "benefit_en"
        case benefitTR = "benefit_tr"
        
        case _source = "source"
    }
    
    let id: Int
    let hadith: Int?
    let rowInCategory: Int
    let text: String
    let category: ZikrCategory
    let audioFileName: String?
    let repeats: Int
    
    private let _title: String?
    private let titleRU: String?
    private let titleEN: String?
    private let titleTR: String?
    
    private let translationRU: String?
    private let translationEN: String?
    private let translationTR: String?
    
    private let _source: String
    
    private let transliterationEN: String?
    private let transliterationRU: String?
    private let transliterationTR: String?
    
    private let _notes: String?
    private let notesRU: String?
    private let notesEN: String?
    private let notesTR: String?
    
    private let _benefit: String?
    private let benefitRU: String?
    private let benefitEN: String?
    private let benefitTR: String?
    
    var title: String? {
        switch languageIdentifier {
        case "ar": return _title
        case "ru": return titleRU
        case "tr": return titleTR
        default: return titleEN
        }
    }
    
    var translation: String? {
        switch languageIdentifier {
        case "ar": return nil
        case "ru": return translationRU
        case "tr": return translationTR
        default: return translationEN
        }
    }
    
    var transliteration: String? {
        switch languageIdentifier {
        case "ar": return nil
        case "ru": return transliterationRU
        case "tr": return transliterationTR
        default: return transliterationEN
        }
    }
    
    var notes: String? {
        switch languageIdentifier {
        case "ar": return nil
        case "ru": return notesRU
        case "tr": return notesTR
        default: return notesEN
        }
    }
    
    var benefit: String? {
        switch languageIdentifier {
        case "ar": return nil
        case "ru": return benefitRU
        case "tr": return benefitTR
        default: return benefitEN
        }
    }
    
    var source: String {
        return _source.components(separatedBy: ",").map {
            NSLocalizedString("text.source." + $0, comment: "")
        }
        .joined(separator: ", ")
    }

    var audioURL: URL? {
        if let name = audioFileName {
            return Bundle.main.url(forAuxiliaryExecutable: name)
        } else {
            return Bundle.main.url(forResource: "\(category.rawValue)\(rowInCategory)", withExtension: "mp3")
        }
    }
    
    var audioDuration: Double? {
        guard let url = audioURL else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    static var data: [Zikr] = {
        let url = Bundle.main.url(forResource: "azkar", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let azkar = try! JSONDecoder().decode([Zikr].self, from: data)
        return azkar
    }()
    
}
