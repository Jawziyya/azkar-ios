import Foundation
import Supabase
import Entities

final class ArticlesAnalyticsService {
    
    private let supabaseClient: SupabaseClient
    private var observationChannels: [Article.ID: Supabase.RealtimeChannelV2] = [:]
    private var observationStreams: [Article.ID: AsyncStream<AnyAction>] = [:]
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
    }
    
    func sendAnalyticsEvent(
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
    
    func getArticleAnalyticsCount(_ articleId: ArticleDTO.ID) async -> ArticleAnalytics? {
        do {
            return try await supabaseClient
                .database
                .from("article_analytics")
                .select("*")
                .eq("article_id", value: articleId)
                .limit(1)
                .single()
                .execute()
                .value
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getAnalyticsStream(for articleId: Article.ID) async -> AsyncStream<AnyAction> {
        let channel: RealtimeChannelV2
        if let existingChannel = observationStreams[articleId] {
            return existingChannel
        } else {
            channel = await supabaseClient.realtimeV2.channel("analytics-\(articleId)")
            observationChannels[articleId] = channel
        }
        let anyChange = await channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "article_analytics",
            filter: String(format: "article_id=eq.%d", articleId)
        )
        observationStreams[articleId] = anyChange
        await channel.subscribe()
        return anyChange
    }
    
    @MainActor
    public func observeAnalyticsNumbers(
        articleId: Article.ID
    ) async -> AsyncStream<ArticleAnalytics> {
        return await getAnalyticsStream(for: articleId)
            .compactMap { action -> ArticleAnalytics? in
                let record: [String: AnyJSON]
                switch action {
                case .update(let update):
                    record = update.record
                case .insert(let insert):
                    record = insert.record
                default:
                    return nil
                }
                let sharesNumber = record["shares_count"]?.intValue ?? 0
                let viewsNumber = record["views_count"]?.intValue ?? 0
                return ArticleAnalytics(views: viewsNumber, shares: sharesNumber)
            }
            .eraseToStream()
    }
    
}

