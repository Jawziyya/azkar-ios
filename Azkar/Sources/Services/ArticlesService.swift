import Foundation
import Supabase
import ArticleReader
import Entities

private let supabaseClient: SupabaseClient = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    let kURL = "SUPABASE_API_URL"
    let kApiKey = "SUPABASE_API_KEY"
    let processEnv = ProcessInfo.processInfo.environment
    let infoPlist = Bundle.main.infoDictionary ?? [:]
    let url = (infoPlist[kURL] as? String)?.textOrNil ?? processEnv[kURL]
    let key = (infoPlist[kApiKey] as? String)?.textOrNil ?? processEnv[kApiKey]
    
    let client = SupabaseClient(
        supabaseURL: URL(string: url!)!,
        supabaseKey: key!,
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
        
        let articleObjects: [ArticleDTO] = try await supabaseClient
            .database
            .from("articles")
            .select()
            .eq("language", value: language.id)
            .eq("is_published", value: true)
            .in("id", value: spotlightArticles.map(\.article))
            .execute()
            .value
        
        let categories: [ArticleCategory] = try await supabaseClient
            .database
            .from("articles_categories")
            .select()
            .execute()
            .value
        
        var articles: [Article] = []
        for articleObject in articleObjects {
            guard let category = categories.first(where: { $0.id == articleObject.category }) else {
                continue
            }
            try await Task.sleep(nanoseconds: 1_000_000_000)
            
            let views = try await supabaseClient
                .database
                .from("analytics")
                .select("*", head: true, count: .exact)
                .eq("action_type", value: AnalyticsRecord.ActionType.view.rawValue)
                .eq("object_id", value: articleObject.id)
                .execute()
                .count
            
            let article = Article(
                articleObject,
                category: category,
                viewsCount: views
            )
            articles.append(article)
        }
        return articles
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
