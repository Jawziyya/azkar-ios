import Foundation
import Entities

public protocol AdsServiceType {
    func fetchAds(newerThan: Date?) async throws -> [Ad]
    func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType)
}
