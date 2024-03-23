import Foundation
import Entities
import GRDB

extension Article: PersistableRecord, FetchableRecord {
    
    static public let databaseTableName = "articles"
    
    public static var databaseColumnEncodingStrategy: DatabaseColumnEncodingStrategy {
        .convertToSnakeCase
    }
    
    public static var databaseColumnDecodingStrategy: DatabaseColumnDecodingStrategy {
        .convertFromSnakeCase
    }
    
}

public final class ArticlesSQLiteDatabaseService: ArticlesRepository {
    
    private let language: Language
    private let databasePool: GRDB.DatabasePool
    
    public init(
        language: Language,
        databaseFilePath: String
    ) throws {
        self.language = language
        databasePool = try DatabasePool(path: databaseFilePath)
        
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create articles") { db in
            try db.create(table: "articles") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("language", .text).notNull()
                t.column("created_at", .datetime).notNull()
                t.column("title", .text).notNull()
                t.column("text", .text).notNull()
                t.column("category", .blob).notNull()
                t.column("text_format", .blob).notNull()
                t.column("cover_image", .blob)
                t.column("cover_image_alt_text", .text)
                t.column("views", .integer)
                t.column("shares", .integer)
                t.column("tags", .blob)
            }
        }
        migrator.eraseDatabaseOnSchemaChange = true
        
        do {
            try migrator.migrate(databasePool)
        } catch {
            print("Error", error.localizedDescription)
        }
    }
    
    /// Cache articles.
    func saveArticles(_ articles: [Article]) async throws {
        try await databasePool.write { db in
            try Article.deleteAll(db, ids: articles.map(\.id))
            for article in articles {
                try article.save(db)
            }
        }
    }
    
    func saveArticle(_ article: Article) async throws {
        try await databasePool.write { db in
            try Article.deleteOne(db, key: article.id)
            try article.save(db)
        }
    }
    
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article] {
        let lang = language.rawValue
        return try await databasePool
            .read { db in
                try Article
                    .filter(sql: "language = ?", arguments: [lang])
                    .order(sql: "created_at DESC")
                    .limit(limit)
                    .fetchAll(db)
            }
    }
    
    func getArticle(_ id: ArticleDTO.ID) async throws -> Article? {
        return try await databasePool
            .read { db in
                try Article.fetchOne(db, id: id)
            }
    }
    
}
