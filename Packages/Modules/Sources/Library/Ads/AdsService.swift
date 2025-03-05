import Foundation
import Entities
import AzkarServices
import DatabaseInteractors

public final class AdsService: AdsServiceType {
    
    let localStorageRepository: AdsRepository
    let remoteStorageRepository: AdsRepository
    let analyticsService: AnalyticsService
    
    public init(
        databasePath: String,
        language: Language
    ) throws {
        let supabaseClient = try getSupabaseClient()
        localStorageRepository = try AdsSQLiteRepository(
            language: language,
            databaseFilePath: databasePath
        )
        remoteStorageRepository = AdsSupabaseRepository(
            supabaseClient: supabaseClient,
            language: language
        )
        analyticsService = AnalyticsService(supabaseClient: supabaseClient)
    }
    
    public func getAd() -> AsyncStream<Ad> {
        AsyncStream { continuation in
            Task {
                do {
                    var createdDate: Date?
                    var updatedDate: Date?
                    let localAds = try await localStorageRepository.getAds(
                        newerThan: nil,
                        orUpdatedAfter: nil,
                        limit: 1
                    )
                    if let ad = localAds.first {
                        createdDate = ad.createdAt
                        updatedDate = ad.updatedAt
                        continuation.yield(ad)
                    }
                    
                    let remoteAds = try await remoteStorageRepository.getAds(
                        newerThan: createdDate,
                        orUpdatedAfter: updatedDate,
                        limit: 1
                    )
                    if let ad = remoteAds.first {
                        try await localStorageRepository.saveAd(ad)
                        continuation.yield(ad)
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish()
                }
            }
        }
    }
    
    public func sendAnalytics(for ad: Ad, action: AnalyticsRecord.ActionType) {
        analyticsService.sendAnalyticsEvent(
            objectId: ad.id,
            recordType: .ad,
            actionType: action
        )
    }
    
}
