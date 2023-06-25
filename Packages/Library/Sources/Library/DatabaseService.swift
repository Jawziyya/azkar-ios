// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Entities
import GRDB

extension Audio: FetchableRecord, TableRecord {
    public static let databaseTableName = "audios"
}

extension Hadith: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "ahadith"
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

extension Fadl: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "fadail"
}

extension AudioTiming: FetchableRecord, PersistableRecord {
    public static let databaseTableName = "audio_timings"
}

public enum DatabaseServiceError: Error {
    case databaseFileAccesingError
}

public final class DatabaseService {

    public static let shared = DatabaseService()

    private init() { }

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
            try Hadith.fetchAll(db)
        }
    }

    public func getHadith(_ id: Int) throws -> Hadith? {
        return try getDatabaseQueue().read { db in
            try Hadith.fetchOne(db, id: id)
        }
    }

    public func getFadailCount() throws -> Int {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchCount(db)
        }
    }

    public func getFadl(_ id: Int) throws -> Fadl? {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchOne(db, id: id)
        }
    }

    public func getRandomFadl() throws -> Fadl? {
        let count = try getFadailCount()
        let id = Int.random(in: 1...count)
        return try getFadl(id)
    }

    public func getFadail() throws -> [Fadl] {
        return try getDatabaseQueue().read { db in
            try Fadl.fetchAll(db)
        }
    }

}

// MARK: - Adhkar
public extension DatabaseService {

    func getZikr(_ id: Int) throws -> Zikr? {
        let langId = languageIdentifier
        return try getDatabaseQueue().read { db in
            let record = try ZikrOrigin.fetchOne(db, id: id)
            let translation = try ZikrTranslation.fetchOne(
                db,
                sql: "SELECT * FROM azkar_\(langId) WHERE id = ?",
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
                sql: "SELECT * FROM azkar_\(languageIdentifier)"
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
            let translationTableName = "azkar_\(languageIdentifier)"
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
            try ZikrOrigin
                .filter(sql: "category = ?", arguments: [category.rawValue])
                .fetchCount(db)
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
