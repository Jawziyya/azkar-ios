// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import GRDB

extension ZikrCounter: @retroactive FetchableRecord, @retroactive PersistableRecord {
    public static let databaseTableName = "counters"
    public static let databaseColumnDecodingStrategy: DatabaseColumnDecodingStrategy = .convertFromSnakeCase
    public static var databaseColumnEncodingStrategy: DatabaseColumnEncodingStrategy = .convertToSnakeCase
}

extension Audio: @retroactive FetchableRecord, @retroactive TableRecord {
    public static let databaseTableName = "audios"
}

extension ZikrOrigin: @retroactive FetchableRecord, @retroactive TableRecord {
    public static let databaseTableName = "azkar"
    public static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
}

extension ZikrTranslation: @retroactive FetchableRecord {
    public init(row: Row) {
        self.init(
            id: row["id"],
            title: row["title"],
            text: row["text"],
            benefits: row["benefits"],
            notes: row["notes"],
            transliteration: row["transliteration"]
        )
    }
}

extension ZikrCollectionData: @retroactive FetchableRecord {
    public init(row: Row) {
        let ids: String = row["azkar_ids"]
        let source: String = row["source"]
        let category: String = row["category"]
        self.init(
            id: row["id"],
            category: ZikrCategory(rawValue: category) ?? .morning,
            azkarIds: ids
                .components(separatedBy: ",")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) },
            source: ZikrCollectionSource(rawValue: source) ?? .hisnulMuslim
        )
    }
}

extension Hadith {
    init(row: Row, language: Language) {
        let sourceRaw: String = row["source"]
        var source = NSLocalizedString("text.source." + sourceRaw.lowercased(), comment: "")
        if let ext = row["source_ext"] as? String {
            source += ", " + ext
        }
        
        self.init(
            id: row["id"],
            text: row["text"],
            translation: row["translation_\(language.id)"],
            source: source
        )
    }
}

extension Fadl {
    init?(row: Row) {
        self.init(
            id: row["id"],
            text: row["text"],
            source: row["source"]
        )
    }
}

extension AudioTiming: @retroactive FetchableRecord, @retroactive PersistableRecord {
    public static let databaseTableName = "audio_timings"
}
