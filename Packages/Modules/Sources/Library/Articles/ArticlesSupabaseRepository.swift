import Foundation
import Entities
import Supabase
import AzkarServices

final class ArticlesSupabaseRepository: ArticlesRepository {
    
    private let supabaseClient: SupabaseClient
    private let language: Language
    private let analyticsService: ArticlesAnalyticsService
    
    // Cache for spotlight articles to ensure we only fetch once
    private var cachedSpotlightArticles: [Article.ID]?
    // Task for fetching spotlight articles to prevent concurrent fetches
    private var spotlightFetchTask: Task<[Article.ID], Error>?
    
    init(
        supabaseClient: SupabaseClient,
        language: Language,
        analyticsService: ArticlesAnalyticsService
    ) {
        self.supabaseClient = supabaseClient
        self.language = language
        self.analyticsService = analyticsService
    }
    
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article] {
        struct Params: Encodable {
            let p_limit: Int
            let p_language: Language
            let p_newer_than: Date?
        }
        
        let params = Params(p_limit: limit, p_language: language, p_newer_than: newerThan?.addingTimeInterval(1))

        struct Response: Decodable {
            let totalCount: Int
            let articles: [Article]
        }

        let articlesResponse: Response = try await supabaseClient
            .rpc("fetch_articles", params: params)
            .execute()
            .value

        return articlesResponse.articles
    }
    
    func saveArticles(_ articles: [Article]) async throws {
        // No effect in remote repository.
    }
    
    func saveArticle(_ article: Article) async throws {
        // No effect in remote repository.
    }
    
    func getArticle(_ id: Article.ID, updatedAfter: Date?) async throws -> Article? {
        struct Params: Encodable {
            let p_article_id: Article.ID
            let p_updated_after: Date?
        }
        
        return try await supabaseClient
            .rpc("fetch_article", params: Params(p_article_id: id, p_updated_after: updatedAfter?.addingTimeInterval(1)))
            .execute()
            .value
    }
    
    func removeArticles(ids: [Article.ID]) async throws {}
    
}
