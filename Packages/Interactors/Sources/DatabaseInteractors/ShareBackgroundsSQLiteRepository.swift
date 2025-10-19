import Foundation
import Entities
import GRDB
import AzkarServices

extension ShareBackground: PersistableRecord, FetchableRecord {
    
    public static let databaseTableName = "share_backgrounds"
    
    public static var databaseColumnEncodingStrategy: DatabaseColumnEncodingStrategy {
        .convertToSnakeCase
    }
    
    public static var databaseColumnDecodingStrategy: DatabaseColumnDecodingStrategy {
        .convertFromSnakeCase
    }
    
}

public final class ShareBackgroundsSQLiteRepository {
    
    private let databasePool: GRDB.DatabasePool
    
    public init(
        databaseFilePath: String
    ) throws {
        databasePool = try DatabasePool(path: databaseFilePath)
        
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create share_backgrounds") { db in
            try db.create(table: "share_backgrounds") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("type", .text).notNull()
                t.column("url", .text).notNull()
                t.column("preview_url", .text)
                t.column("created_at", .datetime).notNull()
            }
        }
        migrator.eraseDatabaseOnSchemaChange = true
        
        do {
            try migrator.migrate(databasePool)
        } catch {
            print("Error", error.localizedDescription)
        }
    }

    public func saveBackgrounds(_ backgrounds: [ShareBackground]) async throws {
        try await databasePool.write { db in
            for background in backgrounds {
                try background.save(db)
            }
        }
    }
    
    public func getBackgrounds() async throws -> [ShareBackground] {
        return try await databasePool
            .read { db in
                try ShareBackground.fetchAll(db)
            }
    }

}
