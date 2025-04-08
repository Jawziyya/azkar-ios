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
    
    func getSpotlightArticles(limit: Int) async throws -> [Article.ID] {
        // Return cached results if available
        if let cachedSpotlightArticles {
            return cachedSpotlightArticles
        }
        
        // If there's already a task fetching spotlight articles, await its result
        if let existingTask = spotlightFetchTask {
            return try await existingTask.value
        }
        
        // Create a new task to fetch spotlight articles
        let task = Task<[Article.ID], Error> { [weak self] in
            guard let self else {
                throw NSError(domain: "ArticlesRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is deallocated"])
            }
            
            // Check again in case another task completed while we were setting up
            if let cachedSpotlightArticles = self.cachedSpotlightArticles {
                return cachedSpotlightArticles
            }
            
            struct SpotlightArticle: Decodable {
                let article: ArticleDTO.ID
            }
            
            let spotlightArticles: [SpotlightArticle] = try await self.supabaseClient
                .from("articles_spotlight")
                .select()
                .order("created_at", ascending: false)
                .limit(limit)
                .execute()
                .value
            
            let articleIDs = spotlightArticles.map(\.article)
            // Cache the result for future calls
            self.cachedSpotlightArticles = articleIDs
            return articleIDs
        }
        
        // Store the task
        spotlightFetchTask = task
        
        do {
            // Await the result
            let result = try await task.value
            // Clear the task after completion
            spotlightFetchTask = nil
            return result
        } catch {
            // Clear the task on error
            spotlightFetchTask = nil
            throw error
        }
    }
    
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article] {
        // Get spotlight article IDs using the existing method
        let spotlightArticleIDs = try await getSpotlightArticles(limit: limit)
        
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
            .in("id", values: spotlightArticleIDs)
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
    
    func removeArticles(ids: [Article.ID]) async throws {}
    
}
