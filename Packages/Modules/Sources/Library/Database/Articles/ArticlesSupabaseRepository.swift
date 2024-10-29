import Foundation
import Entities
import Supabase

final class ArticlesSupabaseRepository: ArticlesRepository {
    
    private let supabaseClient: SupabaseClient
    private let language: Language
    private let analyticsService: ArticlesAnalyticsService
    
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
        struct SpotlightArticle: Decodable {
            let article: ArticleDTO.ID
            let createdAt: Date
        }
        
        let spotlightArticlesQuery = supabaseClient
            .from("articles_spotlight")
            .select()
        
        let spotlightArticles: [SpotlightArticle] = try await spotlightArticlesQuery
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        var articlesQuery = supabaseClient
            .from("articles")
            .select()
            .eq("language", value: language.id)
        
        if CommandLine.arguments.contains("LOAD_ALL_ARTICLES") == false {
            articlesQuery = articlesQuery.eq("is_published", value: true)
            
            if let newerThan {
                let date = newerThan.addingTimeInterval(1).supabaseFormatted
                articlesQuery = articlesQuery
                    .greaterThan("created_at", value: date)
            }
        }
        
        let articleObjects: [ArticleDTO] = try await articlesQuery
            .in("id", values: spotlightArticles.map(\.article))
            .execute()
            .value
        
        var articles: [Article] = []
        
        let sortedArticles = articleObjects
            .sorted(by: { $0.createdAt > $1.createdAt })
        
        for articleObject in sortedArticles {
            let analytics = await analyticsService.getArticleAnalyticsCount(articleObject.id)
            
            let article = Article(
                articleObject,
                viewsCount: analytics?.viewsCount,
                sharesCount: analytics?.sharesCount
            )
            articles.append(article)
        }
        return articles
    }
    
    func saveArticles(_ articles: [Article]) async throws {
        // No effect in remote repository.
    }
    
    func saveArticle(_ article: Article) async throws {
        // No effect in remote repository.
    }
    
    func getArticle(_ id: ArticleDTO.ID, updatedAfter: Date?) async throws -> Article? {
        var query = supabaseClient
            .from("articles")
            .select()
        
        if let updatedAfter {
            query = query
                .greaterThanOrEquals("updated_at", value: updatedAfter.supabaseFormatted)
        }
        
        let article: ArticleDTO = try await query
            .single()
            .execute()
            .value
        let analytics = await analyticsService.getArticleAnalyticsCount(id)
        return Article(
            article,
            viewsCount: analytics?.viewsCount,
            sharesCount: analytics?.sharesCount
        )
    }
    
}
