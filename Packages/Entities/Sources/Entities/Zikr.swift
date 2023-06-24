//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.

import Foundation
import AVFoundation

public struct Zikr: Identifiable, Hashable, Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, hadith
        case text, category, repeats
        case audioId = "audio_id"
        
        case audioFileName = "audio_file_name"
        case rowInCategory = "row_in_category"
        
        case transliterationEN = "transliteration_en"
        case transliterationRU = "transliteration_ru"
        case transliterationTR = "transliteration_tr"
        
        case _title = "title"
        case titleRU = "title_ru"
        case titleEN = "title_en"
        case titleTR = "title_tr"
        case titleKA = "title_ka"
        
        case translationRU = "translation_ru"
        case translationEN = "translation_en"
        case translationTR = "translation_tr"
        case translationKA = "translation_ka"
        
        case _notes = "notes"
        case notesRU = "notes_ru"
        case notesEN = "notes_en"
        case notesTR = "notes_tr"
        case notesKA = "notes_ka"
        
        case _benefit = "benefit"
        case benefitRU = "benefit_ru"
        case benefitEN = "benefit_en"
        case benefitTR = "benefit_tr"
        case benefitKA = "benefit_ka"
        
        case _source = "source"
    }
    
    public let id: Int
    public let hadith: Int?
    public let rowInCategory: Int
    public let text: String
    public let category: ZikrCategory
    public let audioFileName: String?
    public let repeats: Int
    public let audioId: Int?
    
    private let _title: String?
    private let titleRU: String?
    private let titleEN: String?
    private let titleTR: String?
    private let titleKA: String?
    
    private let translationRU: String?
    private let translationEN: String?
    private let translationTR: String?
    private let translationKA: String?
    
    private let _source: String
    
    private let transliterationEN: String?
    private let transliterationRU: String?
    private let transliterationTR: String?
    
    private let _notes: String?
    private let notesRU: String?
    private let notesEN: String?
    private let notesTR: String?
    private let notesKA: String?
    
    private let _benefit: String?
    private let benefitRU: String?
    private let benefitEN: String?
    private let benefitTR: String?
    private let benefitKA: String?
    
    public var title: String? {
        switch languageIdentifier {
        case .ar: return _title
        case .ru: return titleRU
        case .tr: return titleTR
        case .ka: return titleKA
        default: return titleEN
        }
    }
    
    public var translation: String? {
        switch languageIdentifier {
        case .ar: return nil
        case .ru: return translationRU
        case .tr: return translationTR
        case .ka: return translationKA
        default: return translationEN
        }
    }
    
    public var transliteration: String? {
        switch languageIdentifier {
        case .ar: return nil
        case .ru: return transliterationRU
        case .tr: return transliterationTR
        default: return transliterationEN
        }
    }
    
    public var notes: String? {
        switch languageIdentifier {
        case .ar: return nil
        case .ru: return notesRU
        case .tr: return notesTR
        case .ka: return notesKA
        default: return notesEN
        }
    }
    
    public var benefit: String? {
        switch languageIdentifier {
        case .ar: return nil
        case .ru: return benefitRU
        case .tr: return benefitTR
        case .ka: return benefitKA
        default: return benefitEN
        }
    }
    
    public var source: String {
        return _source.components(separatedBy: ", ").map {
            NSLocalizedString("text.source." + $0.lowercased(), comment: "")
        }
        .joined(separator: ", ")
    }

    public var audioURL: URL? {
        if let name = audioFileName {
            return Bundle.main.url(forAuxiliaryExecutable: name)
        } else {
            return Bundle.main.url(forResource: "\(category.rawValue)\(rowInCategory)", withExtension: "mp3")
        }
    }
    
    public var audioDuration: Double? {
        guard let url = audioURL else {
            return nil
        }
        let asset = AVURLAsset(url: url)
        return Double(CMTimeGetSeconds(asset.duration))
    }

    public static var placeholder: Zikr {
        Zikr(
            id: 1,
            hadith: 1,
            rowInCategory: 1,
            text: "Text",
            category: ZikrCategory.other,
            audioFileName: "123.mp3",
            repeats: 1,
            audioId: nil,
            _title: "Title",
            titleRU: "Title RU",
            titleEN: "Title EN",
            titleTR: "Title TR",
            titleKA: "Title KA",
            translationRU: "Translation RU",
            translationEN: "Translation EN",
            translationTR: "Translation TR",
            translationKA: "Translation KA",
            _source: "Source",
            transliterationEN: "Transliteration EN",
            transliterationRU: "Transliteration RU",
            transliterationTR: "Trasnliteration TR",
            _notes: "Notes",
            notesRU: "Notes RU",
            notesEN: "Notes EN",
            notesTR: "Notes TR",
            notesKA: "Notes KA",
            _benefit: "Benefit",
            benefitRU: "Benifit RU",
            benefitEN: "Benefit EN",
            benefitTR: "Benefit TR",
            benefitKA: "Benefit KA"
        )
    }
    
}
