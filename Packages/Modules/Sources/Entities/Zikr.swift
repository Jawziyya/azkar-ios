//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.

import Foundation

public struct ZikrOrigin: Identifiable, Hashable, Codable {
    public let id: Int
    public let text: String
    public let hadith: Int?
    public let repeats: Int
    public let audioId: Int?
    public let source: String
}

public struct ZikrTranslation: Identifiable, Hashable, Codable {
    public let id: Int
    public let title: String?
    public let text: String
    public let benefits: String?
    public let notes: String?
    public let transliteration: String?
    
    public init(id: Int, title: String?, text: String, benefits: String?, notes: String?, transliteration: String?) {
        self.id = id
        self.title = title
        self.text = text
        self.benefits = benefits
        self.notes = notes
        self.transliteration = transliteration
    }
}

public struct Zikr: Identifiable, Hashable {
    
    public let id: Int
    public let hadith: Int?
    public let text: String
    public let category: ZikrCategory?
    public let repeats: Int
    public let title: String?
    public let translation: String?
    public let source: String
    public let transliteration: String?
    public let notes: String?
    public let benefits: String?
    public let audio: Audio?
    public let audioTimings: [AudioTiming]
    public let language: Language
    
    public static func placeholder(
        id: Int = 1
    ) -> Zikr {
        Zikr(
            id: id,
            hadith: 1,
            text: "اللعم اغفر لي\nline 2",
            category: ZikrCategory.other,
            repeats: 1,
            title: "Title",
            translation: "Translation line 1\nline2",
            source: "Source",
            transliteration: "Transliteration line 1\nline2",
            notes: "Notes",
            benefits: "Benefit",
            audio: Audio(id: 1, link: ""),
            audioTimings: [],
            language: .arabic
        )
    }
    
}

extension Zikr {
    public init(
        origin: ZikrOrigin,
        language: Language,
        category: ZikrCategory? = nil,
        translation: ZikrTranslation? = nil,
        audio: Audio? = nil,
        audioTimings: [AudioTiming]
    ) {
        id = origin.id
        self.language = language
        hadith = origin.hadith
        text = origin.text
        self.category = category
        repeats = origin.repeats
        source = origin.source
            .components(separatedBy: ", ").map {
                NSLocalizedString("text.source." + $0.lowercased(), comment: "")
            }
            .joined(separator: ", ")
        title = translation?.title?.textOrNil
        transliteration = translation?.transliteration?.textOrNil
        notes = translation?.notes?.textOrNil
        benefits = translation?.benefits?.textOrNil
        self.audio = audio
        self.translation = translation?.text.textOrNil
        self.audioTimings = audioTimings
    }
}
