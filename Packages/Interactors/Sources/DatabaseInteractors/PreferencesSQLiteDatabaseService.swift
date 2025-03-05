import Foundation
import Entities
import GRDB
import AzkarServices

extension SearchQuery: PersistableRecord, FetchableRecord {
    public static var databaseTableName: String {
        "search_quries"
    }
}
extension RecentZikr: PersistableRecord, FetchableRecord {
    public static var databaseTableName: String {
        "recent_azkar"
    }
}

public final class PreferencesSQLiteDatabaseService: PreferencesDatabaseService {
    
    private var database: DatabaseWriter
    
    public init(
        databasePath: String
    ) throws {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create recent_azkar") { db in
            try db.create(table: RecentZikr.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("zikrId", .integer).notNull()
                t.column("date", .datetime).notNull()
                t.column("language", .text).notNull()
            }
        }
        migrator.registerMigration("Create search_queries") { db in
            try db.create(table: SearchQuery.databaseTableName) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("text", .text).notNull()
                t.column("date", .datetime).notNull()
            }
        }
        
        let config = GRDB.Configuration()
        database = try DatabasePool(path: databasePath, configuration: config)
        try migrator.migrate(database)
    }
    
    public func storeSearchQuery(_ query: String) async {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard normalizedQuery.isEmpty == false else {
            return
        }
        do {
            try await database.write { db in
                if var existingRecord = try SearchQuery
                    .filter(sql: "text = ?", arguments: [normalizedQuery])
                    .fetchOne(db)
                {
                    existingRecord.date = Date()
                    try existingRecord.update(db)
                } else {
                    try SearchQuery(text: normalizedQuery, date: Date()).insert(db)
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func deleteSearchQuery(_ query: String) async {
        do {
            try await database.write { db in
                guard let object = try SearchQuery
                    .filter(sql: "text = ?", arguments: [query])
                    .fetchOne(db)
                else {
                    return
                }
                try object.delete(db)
            }
        } catch {
            print(error)
        }
    }
    
    public func clearSearchQueries() async {
        do {
            _ = try await database.write { db in
                try SearchQuery.deleteAll(db)
            }
        } catch {
            print(error)
        }
    }
    
    public func getRecentSearchQueries(limit: UInt8) async -> [String] {
        do {
            return try await database.read { db in
                return try SearchQuery
                    .order(sql: "date DESC")
                    .limit(Int(limit))
                    .fetchAll(db)
                    .map(\.text)
            }
        } catch {
            print(error)
            return []
        }
    }
    
    public func storeOpenedZikr(_ id: Zikr.ID, language: Language) async {
        do {
            try await database.write { db in
                if var existingRecord = try RecentZikr
                    .filter(
                        sql: "zikrId = ? AND language = ?",
                        arguments: [id, language.rawValue]
                    )
                    .fetchOne(db)
                {
                    existingRecord.date = Date()
                    try existingRecord.update(db)
                } else {
                    try RecentZikr(zikrId: id, date: Date(), language: language).insert(db)
                }
            }
        } catch {
            print(error)
        }
    }
    
    public func deleteRecentZikr(_ id: Zikr.ID, language: Language) async {
        do {
            _ = try await database.write { db in
                try RecentZikr
                    .filter(sql: "zikrId = ? AND language = ?", arguments: [id, language.rawValue])
                    .deleteAll(db)
            }
        } catch {
            print(error)
        }
    }
    
    public func getRecentAzkar(limit: UInt8) async -> [RecentZikr] {
        do {
            return try await database.read { db in
                try RecentZikr
                    .order(sql: "date DESC")
                    .limit(Int(limit))
                    .fetchAll(db)
            }
        } catch {
            print(error)
            return []
        }
    }
    
    public func clearRecentAzkar() async {
        do {
            _ = try await database.write { db in
                try RecentZikr.deleteAll(db)
            }
        } catch {
            print(error)
        }
    }
    
}
