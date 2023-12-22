// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Entities
import GRDB

extension Language {
    var databaseTableName: String {
        switch self {
        case .arabic: return "azkar"
        default: return "azkar_\(self.id)"
        }
    }
}

public final class AdhkarSQLiteDatabaseService: AdhkarDatabaseService {
    
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
            return try DatabaseHelper.tableExists(language.databaseTableName, databaseQueue: getDatabaseQueue())
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
    
    private func getAudio(_ audioId: Int, database: Database) throws -> Audio? {
        try Audio.fetchOne(
            database,
            sql: "SELECT * FROM audios WHERE id = ?",
            arguments: [audioId]
        )
    }
    
    private func getAudioTimings(_ audioId: Int, database: Database) throws -> [AudioTiming] {
        try AudioTiming.fetchAll(
            database,
            sql: "SELECT * FROM audio_timings WHERE audio_id = ?",
            arguments: [audioId]
        )
    }

}

// MARK: - Adhkar
public extension AdhkarSQLiteDatabaseService {

    func getZikr(_ id: Int, language: Language?) throws -> Zikr? {
        let lang = language ?? self.language
        return try getDatabaseQueue().read { db in
            let record = try ZikrOrigin.fetchOne(db, id: id)
            let translation = try ZikrTranslation.fetchOne(
                db,
                sql: "SELECT * FROM \(lang.databaseTableName) WHERE id = ?",
                arguments: [id]
            )
            guard let record, let translation else {
                return nil
            }
            
            let audio = try record.audioId.flatMap { id in
                try getAudio(id, database: db)
            }
            let audioTimings = try record.audioId.flatMap { id in
                try getAudioTimings(id, database: db)
            }
            
            return Zikr(
                origin: record,
                language: lang,
                category: nil,
                translation: translation,
                audio: audio,
                audioTimings: audioTimings ?? []
            )
        }
    }
    
    func getZikrBeforeBreakingFast() -> Zikr? {
        let fastBreakingZikrId = 48
        return try? getZikr(fastBreakingZikrId, language: language)
    }

    func getAllAdhkar() throws -> [Zikr] {
        return try getDatabaseQueue().read { db in
            let records = try ZikrOrigin.fetchAll(db, sql: "SELECT * FROM azkar")
            let translations = try ZikrTranslation.fetchAll(
                db,
                sql: "SELECT * FROM \(language.databaseTableName)"
            )
            return zip(records, translations).map { zikr, translation in
                Zikr(
                    origin: zikr,
                    language: language,
                    category: nil,
                    translation: translation,
                    audio: nil,
                    audioTimings: []
                )
            }
        }
    }
    
    func getAdhkar(_ category: ZikrCategory, language: Language?) throws -> [Zikr] {
        let lang = language ?? self.language
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
            let translationTableName = "azkar_\(lang.id)"
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
                    language: lang,
                    category: category,
                    translation: translation,
                    audio: audio,
                    audioTimings: audioTimings.filter { $0.audioId == audio?.id }
                )
            }
        }
    }
    
    func searchAdhkar(
        _ query: String,
        category: ZikrCategory,
        languages: [Language]
    ) async throws -> [Zikr] {
        return try await getDatabaseQueue().read { db in
            try self.getSearchResults(
                for: query,
                category: category,
                languages: languages,
                from: db
            )
        }
    }
    
    private func normalizeSearchQuery(_ query: String) -> String {
        query
            .replacingOccurrences(of: "Ё|ё|Е|е", with: "*", options: .regularExpression)
        + "*"
    }

    private func getSearchResults(
        for query: String,
        category: ZikrCategory,
        languages: [Language],
        from db: Database
    ) throws -> [Zikr] {
        let normalizedQuery = normalizeSearchQuery(query)
        var azkar: [Zikr] = []
                
        for language in languages {
            
            let tableName = language.databaseTableName
            let translations = try ZikrTranslation.fetchAll(
                db,
                sql: """
                SELECT \(tableName).*
                FROM \(tableName)
                JOIN "azkar+azkar_group" ON \(tableName).id = "azkar+azkar_group"."azkar_id"
                WHERE "azkar+azkar_group"."group" = ?
                AND \(tableName).id IN (
                    SELECT rowid FROM azkar_search WHERE text_\(language.id) MATCH ?
                )
                ORDER BY "azkar+azkar_group"."order"
                """,
                arguments: [category.rawValue, normalizedQuery]
            )
            
            for translation in translations {
                let zikrId = translation.id
                guard let origin = try ZikrOrigin.fetchOne(
                    db,
                    sql: "SELECT * FROM azkar WHERE id = ?",
                    arguments: [zikrId]
                ) else {
                    continue
                }
                
                let audio = try origin.audioId.flatMap { id in
                    try getAudio(id, database: db)
                }
                let audioTimings = try origin.audioId.flatMap { id in
                    try getAudioTimings(id, database: db)
                }
                let zikr = Zikr(
                    origin: origin,
                    language: language,
                    category: category,
                    translation: translation,
                    audio: audio,
                    audioTimings: audioTimings ?? []
                )
                azkar.append(zikr)
            }
        }
        
        return azkar
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
    
    func getAudio(audioId: Int) async throws -> Audio? {
        return try await getDatabaseQueue().read { db in
            try self.getAudio(audioId, database: db)
        }
    }

    func getAudioTimings(audioId: Int) async throws -> [AudioTiming] {
        return try await getDatabaseQueue().read { db in
            try self.getAudioTimings(audioId, database: db)
        }
    }

}
