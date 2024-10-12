import Foundation
import Entities
import Supabase

public final class AdsService: AdsServiceType {
    
    let supabaseClient: SupabaseClient
    let analyticsService: AnalyticsService
    
    public init(
    ) throws {
        self.supabaseClient = try getSupabaseClient()
        analyticsService = AnalyticsService(supabaseClient: supabaseClient)
    }
    
    public func fetchAds(newerThan: Date?) async throws -> [Ad] {
        var articlesQuery = supabaseClient
            .from("ads")
            .select()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let newerThan {
            let date = formatter.string(from: newerThan.addingTimeInterval(1))
            articlesQuery = articlesQuery
                .greaterThan("created_at", value: date)
        }
        articlesQuery = articlesQuery.greaterThan(
            "expire_date",
            value: formatter.string(from: Date())
        )
        let ads: [Ad] = try await articlesQuery.execute().value
        return ads
    }
    
    public func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType) {
        analyticsService.sendAnalyticsEvent(
            objectId: ad.id,
            recordType: .ad,
            actionType: action
        )
    }
    
}
