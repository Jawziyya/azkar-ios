import Foundation
import Entities
import Library

final class DemoAdsService: AdsServiceType {
    func getAd() -> AsyncStream<Entities.Ad> {
        return AsyncStream<Ad> { continuation in
            continuation.yield(Ad.telegramBotDemo)
            continuation.finish()
        }
    }
    func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType) {}
}
