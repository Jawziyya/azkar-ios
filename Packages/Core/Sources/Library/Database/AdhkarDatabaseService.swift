// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Entities
import GRDB

public final class AdhkarDatabaseService {
    
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
    
    public func translationExists(for language: Language) -> Bool {
        do {
            let tableName = "azkar_\(language.id)"
            return try DatabaseHelper.tableExists(tableName, databaseQueue: getDatabaseQueue())
        } catch {
            return false
        }
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
public extension AdhkarDatabaseService {

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
                sql: """
                SELECT azkar.*
                FROM azkar
                JOIN "azkar+azkar_group" ON azkar.id = "azkar+azkar_group"."azkar_id"
                WHERE "azkar+azkar_group"."group" = ?
                ORDER BY "azkar+azkar_group"."order"
                """,
                arguments: [category.rawValue]
            )
            let translationTableName = "azkar_\(language.id)"
            let translations = try ZikrTranslation.fetchAll(
                db,
                sql: """
                SELECT \(translationTableName).*
                FROM \(translationTableName)
                JOIN "azkar+azkar_group" ON \(translationTableName).id = "azkar+azkar_group"."azkar_id"
                WHERE "azkar+azkar_group"."group" = ?
                ORDER BY "azkar+azkar_group"."order"
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
