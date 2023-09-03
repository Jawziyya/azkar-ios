// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import GRDB

extension ZikrCounter: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "counters"
    public static let databaseColumnDecodingStrategy: DatabaseColumnDecodingStrategy = .convertFromSnakeCase
    public static var databaseColumnEncodingStrategy: DatabaseColumnEncodingStrategy = .convertToSnakeCase
}

extension Audio: FetchableRecord, TableRecord {
    public static let databaseTableName = "audios"
}

extension ZikrOrigin: FetchableRecord, TableRecord {
    public static let databaseTableName = "azkar"
    public static let databaseColumnDecodingStrategy = DatabaseColumnDecodingStrategy.convertFromSnakeCase
}

extension ZikrTranslation: FetchableRecord {
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
    init?(row: Row, language: Language) {
        let sourceRaw: String = row["source"]
        var source = NSLocalizedString("text.source." + sourceRaw.lowercased(), comment: "")
        if let ext = row["source_ext"] as? String {
            source += ", " + ext
        }
        
        let text: String? = row["text_\(language.id)"]
        
        self.init(
            id: row["id"],
            text: text,
            source: source
        )
    }
}

extension AudioTiming: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "audio_timings"
}
