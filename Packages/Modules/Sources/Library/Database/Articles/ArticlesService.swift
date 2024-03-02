import SwiftUI
import Entities
import Supabase

public struct ArticlesAnalyticsEvent: Encodable {
    public let actionType: AnalyticsRecord.ActionType
    public let objectId: Int
    public let recordType: String
    
    public init(
        actionType: AnalyticsRecord.ActionType,
        objectId: Int,
        recordType: String
    ) {
        self.actionType = actionType
        self.objectId = objectId
        self.recordType = recordType
    }
}

public protocol ArticlesServiceType {
    func getArticles(limit: Int) -> AsyncThrowingStream<[Article], Error>
    func getArticle(_ id: Article.ID) async throws -> Article?
    func sendAnalyticsEvent(_ type: AnalyticsRecord.ActionType, articleId: Article.ID) async
}

public final class ArticlesService: ArticlesServiceType {
    
    private var localRepository: ArticlesRepository?
    private let remoteRepository: ArticlesRepository
    
    public init(
        databasePath: String,
        language: Language
    ) {
        do {
            localRepository = try ArticlesSQLiteDatabaseService(language: language, databaseFilePath: databasePath)
        } catch {
            print(error.localizedDescription)
        }
        remoteRepository = ArticlesSupabaseRepository(language: language)
    }
    
    public func getArticles(
        limit: Int
    ) -> AsyncThrowingStream<[Article], Error> {
        let remoteRepository = self.remoteRepository
        guard let localRepository else {
            return AsyncThrowingStream {
                return try await remoteRepository.getArticles(limit: limit, newerThan: nil)
            }
        }
                
        return AsyncThrowingStream { continuation in
            Task {
                var cachedArticles: [Article] = []
                do {
                    cachedArticles = try await localRepository.getArticles(limit: limit, newerThan: nil)
                    if cachedArticles.isEmpty == false {
                        continuation.yield(cachedArticles)
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
                
                let newestArticleDate = cachedArticles.first?.createdAt
                do {
                    let articles = try await remoteRepository.getArticles(limit: limit, newerThan: newestArticleDate)
                    try await localRepository.saveArticles(articles)
                    continuation.yield(articles + cachedArticles)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    /// Get list of articles for a given language.
    public func fetchArticles(
        limit: Int
    ) async throws -> [Article] {
        return try await remoteRepository.getArticles(limit: limit, newerThan: nil)
    }
    
    /// Request an article using article.id
    public func getArticle(
        _ id: Article.ID
    ) async throws -> Article? {
        if let article = try await localRepository?.getArticle(id) {
            return article
        } else {
            let article = try await remoteRepository.getArticle(id)
            if let article {
                try? await localRepository?.saveArticles([article])
            }
            return article
        }
    }

    /// Report analytics event.
    public func sendAnalyticsEvent(
        _ type: AnalyticsRecord.ActionType,
        articleId: Article.ID
    ) async {
        do {
            try await supabaseClient
                .database
                .from("analytics")
                .insert(ArticlesAnalyticsEvent(
                    actionType: type,
                    objectId: articleId,
                    recordType: AnalyticsRecord.RecordType.article.rawValue
                ))
                .execute()
                .value
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
