import Foundation
import Entities

public protocol AdsRepository {
    func getAds(
        newerThan: Date?,
        orUpdatedAfter: Date?,
        limit: Int
    ) async throws -> [Ad]
    func saveAd(_ ad: Ad) async throws
    func saveAds(_ ads: [Ad]) async throws
    func getAd(_ id: Ad.ID) async throws -> Ad?
}
