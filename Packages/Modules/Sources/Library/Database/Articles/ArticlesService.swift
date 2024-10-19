import SwiftUI
import Entities
import Supabase
import Combine

public final class ArticlesService: ArticlesServiceType {
    
    private let localRepository: ArticlesRepository
    private let remoteRepository: ArticlesRepository
    private let articlesAnalyticsService: ArticlesAnalyticsService
    
    public init(
        databasePath: String,
        language: Language
    ) throws {
        let supabaseClient = try getSupabaseClient()
        localRepository = try ArticlesSQLiteDatabaseService(language: language, databaseFilePath: databasePath)
        articlesAnalyticsService = ArticlesAnalyticsService(supabaseClient: supabaseClient)
        remoteRepository = ArticlesSupabaseRepository(
            supabaseClient: supabaseClient,
            language: language,
            analyticsService: articlesAnalyticsService
        )
    }
    
    public func getArticles(
        limit: Int
    ) -> AsyncThrowingStream<[Article], Error> {
        let remoteRepository = self.remoteRepository
        let localRepository = self.localRepository
                
        return AsyncThrowingStream { continuation in
            Task {
                var cachedArticles: [Article] = []
                do {
                    let articles = try await localRepository.getArticles(limit: limit, newerThan: nil)
                    cachedArticles = articles
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
                    let allArticles = (articles + cachedArticles).unique(by: \.id)
                    if allArticles != cachedArticles {
                        continuation.yield(allArticles)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    /// Request an article using article.id
    public func getArticle(
        _ id: Article.ID
    ) async throws -> Article? {
        if let article = try await localRepository.getArticle(id) {
            return article
        } else {
            let article = try await remoteRepository.getArticle(id)
            if let article {
                try? await localRepository.saveArticles([article])
            }
            return article
        }
    }
        
    public func updateAnalyticsNumbers(
        for articleId: Article.ID,
        views: Int,
        shares: Int
    ) {
        Task {
            if var article = try? await localRepository.getArticle(articleId) {
                article.views = views
                article.shares = shares
                try? await localRepository.saveArticle(article)
            }
        }
    }

    /// Report analytics event.
    public func sendAnalyticsEvent(
        _ type: AnalyticsRecord.ActionType,
        articleId: Article.ID
    ) {
        articlesAnalyticsService.sendAnalyticsEvent(type, articleId: articleId)
    }
    
    public func observeAnalyticsNumbers(
        articleId: Article.ID
    ) async -> AsyncStream<ArticleAnalytics> {
        await articlesAnalyticsService.observeAnalyticsNumbers(articleId: articleId)
    }
    
}
