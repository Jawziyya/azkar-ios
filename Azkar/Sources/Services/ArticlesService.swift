import Foundation
import Supabase
import ArticleReader
import Entities

private let supabaseClient: SupabaseClient = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let client = SupabaseClient(
        supabaseURL: URL(string: ProcessInfo.processInfo.environment["SUPABASE_API_URL"]!)!,
        supabaseKey: ProcessInfo.processInfo.environment["SUPABASE_API_KEY"]!,
        options: SupabaseClientOptions(
            db: .init(
                encoder: encoder,
                decoder: decoder
            )
        )
    )
    return client
}()

final class ArticlesService {
    
    enum AnalyticsActionType: String, Encodable {
        case view, share
    }
    
    struct AnalyticsEvent: Encodable {
        let actionType: AnalyticsActionType
        let objectId: Int
        let recordType = "article"
    }
    
    static let shared = ArticlesService()
    
    private init() {}
    
    func getArticles(language: Language, limit: Int) async throws -> [Article] {
        struct SpotlightArticle: Decodable {
            let article: Article.ID
        }
        
        let spotlightArticles: [SpotlightArticle] = try await supabaseClient
            .database
            .from("articles_spotlight")
            .select()
            .limit(limit)
            .execute()
            .value
        
        let articles: [ArticleDTO] = try await supabaseClient
            .database
            .from("articles")
            .select()
            .eq("language", value: language.id)
            .in("id", value: spotlightArticles.map(\.article))
            .execute()
            .value
        
        let categories: [ArticleCategory] = try await supabaseClient
            .database
            .from("articles_categories")
            .select()
            .execute()
            .value
        
        return articles.compactMap { article -> Article? in
            guard let category = categories.first(where: { $0.id == article.category }) else {
                return nil
            }
            
            return Article(
                article,
                category: category,
                viewsCount: nil
            )
        }
    }
    
    func sendAnalyticsEvent(_ type: AnalyticsActionType, articleId: Article.ID) async {
        do {
            try await supabaseClient
                .database
                .from("analytics")
                .insert(AnalyticsEvent(actionType: type, objectId: articleId))
                .execute()
                .value
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
