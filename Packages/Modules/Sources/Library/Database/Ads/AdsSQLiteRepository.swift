import Foundation
import Entities
import GRDB

extension Ad: PersistableRecord, FetchableRecord {
    
    static public let databaseTableName = "ads"
    
    public static var databaseColumnEncodingStrategy: DatabaseColumnEncodingStrategy {
        .convertToSnakeCase
    }
    
    public static var databaseColumnDecodingStrategy: DatabaseColumnDecodingStrategy {
        .convertFromSnakeCase
    }
    
}

final class AdsSQLiteRepository: AdsRepository {
    
    private let language: Language
    private let databasePool: GRDB.DatabasePool
    
    init(
        language: Language,
        databaseFilePath: String
    ) throws {
        self.language = language
        databasePool = try DatabasePool(path: databaseFilePath)
        
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create ads") { db in
            try db.create(table: "ads") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("title", .text)
                t.column("body", .text)
                t.column("action_title", .text)
                t.column("action_link", .text)
                t.column("image_link", .text)
                
                t.column("background_color", .text)
                t.column("foreground_color", .text)
                t.column("accent_color", .text)
                
                t.column("size", .text).notNull()
                t.column("image_mode", .text).notNull()
                t.column("language", .text).notNull()
                
                t.column("created_at", .datetime).notNull()
                t.column("updated_at", .datetime).notNull()
                t.column("begin_date", .datetime).notNull()
                t.column("expire_date", .datetime).notNull()
            }
        }
        migrator.eraseDatabaseOnSchemaChange = true
        
        do {
            try migrator.migrate(databasePool)
        } catch {
            print("Error", error.localizedDescription)
        }
    }
    
    func getAds(
        newerThan: Date?,
        orUpdatedAfter: Date?,
        limit: Int
    ) async throws -> [Ad] {
        let lang = language.rawValue
        return try await databasePool
            .read { db in
                var query = Ad
                    .filter(sql: "language = ?", arguments: [lang])
                
                if let orUpdatedAfter {
                    let updateDate = orUpdatedAfter.addingTimeInterval(1).supabaseFormatted
                    if let newerThan {
                        let createDate = newerThan.addingTimeInterval(1).supabaseFormatted
                        query = query
                            .filter(sql: "created_at > ? OR updated_at > ?", arguments: [
                                createDate,
                                updateDate
                            ])
                    } else {
                        query = query.filter(sql: "updated_at > ?", arguments: [updateDate])
                    }
                } else if let newerThan {
                    let date = newerThan.addingTimeInterval(1).supabaseFormatted
                    query = query.filter(sql: "created_at > ?", arguments: [date])
                }
                
                let formattedDate = Date().supabaseFormatted
                
                return try query
                    .filter(sql: "begin_date < ?", arguments: [formattedDate])
                    .filter(sql: "expire_date > ?", arguments: [formattedDate])
                    .order(sql: "created_at DESC")
                    .limit(limit)
                    .fetchAll(db)
            }
    }
    
    func getAd(_ id: Ad.ID) async throws -> Ad? {
        return try await databasePool
            .read { db in
                try Ad.fetchOne(db, id: id)
            }
    }
    
    func saveAds(_ ads: [Ad]) async throws {
        try await databasePool.write { db in
            try Ad.deleteAll(db, ids: ads.map(\.id))
            for ad in ads {
                try ad.save(db)
            }
        }
    }
    
    func saveAd(_ ad: Ad) async throws {
        try await databasePool.write { db in
            try Ad.deleteOne(db, key: ad.id)
            try ad.save(db)
        }
    }
    
}
