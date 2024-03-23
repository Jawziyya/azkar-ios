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

public struct AnalyticsNumbers {
    public let views: Int
    public let shares: Int
    
    public init(views: Int, shares: Int) {
        self.views = views
        self.shares = shares
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
                    let articles = try await localRepository.getArticles(limit: limit, newerThan: nil)
                    cachedArticles = articles
                    Task.detached { [self, articles] in
                        for article in articles {
                            await updateAnalyticsNumbers(for: article.id)
                        }
                    }
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
                    let allArticles = articles + cachedArticles
                    continuation.yield(allArticles.unique(by: \.id))
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    public func updateAnalyticsNumbers(for articleId: Article.ID) async {
        func getArticleAnalyticsCount(
            _ articleId: ArticleDTO.ID,
            actionType: AnalyticsRecord.ActionType
        ) async -> Int? {
            try? await supabaseClient
                .database
                .from("analytics")
                .select("*", head: true, count: .exact)
                .eq("action_type", value: actionType.rawValue)
                .eq("object_id", value: articleId)
                .execute()
                .count
        }
        
        let views = await getArticleAnalyticsCount(articleId, actionType: .view)
        let shares = await getArticleAnalyticsCount(articleId, actionType: .share)
        if var article = try? await localRepository?.getArticle(articleId) {
            article.views = views
            article.shares = shares
            try? await localRepository?.saveArticle(article)
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
