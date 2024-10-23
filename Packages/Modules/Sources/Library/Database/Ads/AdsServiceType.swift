import Foundation
import Entities

public protocol AdsServiceType {
    func getAd() -> AsyncStream<Ad>
    func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType)
}
