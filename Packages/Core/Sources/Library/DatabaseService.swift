// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Entities
import GRDB

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

public enum DatabaseServiceError: Error {
    case databaseFileAccesingError
}

public final class DatabaseService {
    
    public let language: Language

    public init(
        language: Language
    ) {
        self.language = language
    }

    private func getDatabasePath() throws -> String {
        guard let path = Bundle.main.path(forResource: "azkar", ofType: "db") else {
            throw DatabaseServiceError.databaseFileAccesingError
        }
        return path
    }

    private func getDatabaseQueue() throws -> DatabaseQueue {
        var config = Configuration()
        config.readonly = true
        return try DatabaseQueue(path: getDatabasePath(), configuration: config)
    }

    public func getAhadith() throws -> [Hadith] {
        return try getDatabaseQueue().read { db in
            let ahadith = try Row.fetchAll(db, sql: "SELECT * FROM ahadith")
            return ahadith.map { row in
                Hadith(row: row, language: language)
            }
        }
    }

    public func getHadith(_ id: Int) throws -> Hadith? {
        return try getDatabaseQueue().read { db in
            if let hadith = try Row.fetchOne(db, sql: "SELECT * FROM ahadith WHERE id = ?", arguments: [id]) {
                return Hadith(row: hadith, language: language)
            }
            return nil
        }
    }

    public func getFadailCount() throws -> Int {
        return try getDatabaseQueue().read { db in
            if let row = try Row.fetchOne(db, sql: "SELECT COUNT(*) as count FROM fadail") {
                return row["count"]
            }
            return 0
        }
    }

    public func getFadl(_ id: Int, language: Language? = nil) throws -> Fadl? {
        return try getDatabaseQueue().read { db in
            if let fadl = try Row.fetchOne(db, sql: "SELECT * FROM fadail WHERE id = ?", arguments: [id]) {
                return Fadl(row: fadl, language: language ?? self.language)
            }
            return nil
        }
    }

    public func getRandomFadl(language: Language? = nil) throws -> Fadl? {
        let count = try getFadailCount()
        let id = Int.random(in: 1...count)
        return try getFadl(id, language: language)
    }

    public func getFadail(language: Language? = nil) throws -> [Fadl] {
        return try getDatabaseQueue().read { db in
            let fadail = try Row.fetchAll(db, sql: "SELECT * FROM fadail")
            return fadail.compactMap { row in
                Fadl(row: row, language: language ?? self.language)
            }
        }
    }

}

// MARK: - Adhkar
public extension DatabaseService {

    func getZikr(_ id: Int) throws -> Zikr? {
        return try getDatabaseQueue().read { db in
            let record = try ZikrOrigin.fetchOne(db, id: id)
            let translation = try ZikrTranslation.fetchOne(
                db,
                sql: "SELECT * FROM azkar_\(language.id) WHERE id = ?",
                arguments: [id]
            )
            guard let record, let translation else {
                return nil
            }
            
            return Zikr(
                origin: record,
                translation: translation,
                audio: nil,
                audioTimings: []
            )
        }
    }

    func getAllAdhkar() throws -> [Zikr] {
        return try getDatabaseQueue().read { db in
            let records = try ZikrOrigin.fetchAll(db, sql: "SELECT * FROM azkar")
            let translations = try ZikrTranslation.fetchAll(
                db,
                sql: "SELECT * FROM azkar_\(language.id)"
            )
            return zip(records, translations).map { zikr, translation in
                Zikr(
                    origin: zikr,
                    translation: translation,
                    audio: nil,
                    audioTimings: []
                )
            }
        }
    }

    func getAdhkar(_ category: ZikrCategory) throws -> [Zikr] {
        return try getDatabaseQueue().read { db in
            let records = try ZikrOrigin.fetchAll(
                db,
                sql: "SELECT * FROM azkar WHERE category = ?",
                arguments: [category.rawValue]
            )
            let translationTableName = "azkar_\(language.id)"
            let translations = try ZikrTranslation.fetchAll(
                db,
                sql: """
                SELECT * FROM \(translationTableName)
                WHERE \(translationTableName).id IN (
                  SELECT id FROM azkar WHERE azkar.category = ?
                )
                """,
                arguments: [category.rawValue]
            )
            
            let audios = try Audio.fetchAll(db)
            let audioTimings = try AudioTiming.fetchAll(db)

            return zip(records, translations).map { zikr, translation -> Zikr in
                let audio = audios.first(where: { $0.id == zikr.audioId })
                
                return Zikr(
                    origin: zikr,
                    translation: translation,
                    audio: audio,
                    audioTimings: audioTimings.filter { $0.audioId == audio?.id }
                )
            }
        }
    }

    func getAdhkarCount(_ category: ZikrCategory) throws -> Int {
        return try getDatabaseQueue().read { db in
            guard let row = try Row
                .fetchOne(
                    db,
                    sql: """
                    SELECT COUNT(*) AS count FROM "azkar+azkar_group"
                    WHERE "group" = ?
                    """,
                    arguments: [category.rawValue]
                )
            else {
                return 0
            }
            return row["count"]
        }
    }

    func getAudioTimings(audioId: Int) throws -> [AudioTiming] {
        return try getDatabaseQueue().read { db in
            try AudioTiming
                .filter(sql: "audio_id = ?", arguments: [audioId])
                .fetchAll(db)
        }
    }

}
