import Foundation
import Entities
import Library

final class DemoAdsService: AdsServiceType {
    func fetchAds(newerThan: Date?) async throws -> [Ad] {
        return []
    }
    func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType) {}
}
