import Foundation
import Entities
import Supabase

let supabaseClient: SupabaseClient = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    // First formatter with fractional seconds
    let formatterWithFractionalSeconds = DateFormatter()
    formatterWithFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    formatterWithFractionalSeconds.timeZone = TimeZone(secondsFromGMT: 0)
    formatterWithFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")

    // Second formatter without fractional seconds
    let formatterWithoutFractionalSeconds = DateFormatter()
    formatterWithoutFractionalSeconds.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatterWithoutFractionalSeconds.timeZone = TimeZone(secondsFromGMT: 0)
    formatterWithoutFractionalSeconds.locale = Locale(identifier: "en_US_POSIX")

    // Custom date decoding strategy
    decoder.dateDecodingStrategy = .custom { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        if let date = formatterWithFractionalSeconds.date(from: dateString) {
            return date
        } else if let date = formatterWithoutFractionalSeconds.date(from: dateString) {
            return date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string: \(dateString)")
        }
    }
    
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    
    let kURL = "SUPABASE_API_URL"
    let kApiKey = "SUPABASE_API_KEY"
    let processEnv = ProcessInfo.processInfo.environment
    let infoPlist = Bundle.main.infoDictionary ?? [:]
    guard
        let rawURL = (infoPlist[kURL] as? String)?.textOrNil ?? processEnv[kURL],
        let url = URL(string: rawURL),
        let key = (infoPlist[kApiKey] as? String)?.textOrNil ?? processEnv[kApiKey]
    else {
        fatalError("You must provide Supabase API key & url address.")
    }
    
    let client = SupabaseClient(
        supabaseURL: url,
        supabaseKey: key,
        options: SupabaseClientOptions(
            db: .init(
                encoder: encoder,
                decoder: decoder
            )
        )
    )
    return client
}()

final class ArticlesSupabaseRepository: ArticlesRepository {
    
    private let language: Language
    
    init(language: Language) {
        self.language = language
    }
    
    func getArticles(limit: Int, newerThan: Date?) async throws -> [Article] {
        struct SpotlightArticle: Decodable {
            let article: ArticleDTO.ID
            let createdAt: Date
        }
        
        let spotlightArticlesQuery = await supabaseClient
            .database
            .from("articles_spotlight")
            .select()
        
        let spotlightArticles: [SpotlightArticle] = try await spotlightArticlesQuery
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        var articlesQuery = await supabaseClient
            .database
            .from("articles")
            .select()
            .eq("language", value: language.id)
            .eq("is_published", value: true)
        
        if let newerThan {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            let date = formatter.string(from: newerThan.addingTimeInterval(1))
            articlesQuery = articlesQuery
                .greaterThan("created_at", value: date)
        }
        
        let articleObjects: [ArticleDTO] = try await articlesQuery
            .in("id", value: spotlightArticles.map(\.article))
            .execute()
            .value
        
        let categories = try await getCategories()
        
        var articles: [Article] = []
        for articleObject in articleObjects {
            guard let category = categories.first(where: { $0.id == articleObject.category }) else {
                continue
            }
            
            let views = await getArticleAnalyticsCount(
                articleObject.id,
                actionType: .view
            )
            
            let shares = await getArticleAnalyticsCount(
                articleObject.id,
                actionType: .share
            )
            
            let article = Article(
                articleObject,
                category: category,
                viewsCount: views,
                sharesCount: shares
            )
            articles.append(article)
        }
        return articles
    }
    
    func saveArticles(_ articles: [Article]) async throws {
        // No effect in remote repository.
    }
    
    func getArticle(_ id: ArticleDTO.ID) async throws -> Article? {
        return nil
    }
    
}

private extension ArticlesSupabaseRepository {
    func getCategories() async throws -> [ArticleCategory] {
        try await supabaseClient
            .database
            .from("articles_categories")
            .select()
            .execute()
            .value
    }
    
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
}
