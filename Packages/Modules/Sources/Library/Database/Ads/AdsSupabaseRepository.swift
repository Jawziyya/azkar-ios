import Foundation
import Supabase
import Entities

final class AdsSupabaseRepository: AdsRepository {
    
    private let supabaseClient: SupabaseClient
    private let language: Language
    
    init(
        supabaseClient: SupabaseClient,
        language: Language
    ) {
        self.supabaseClient = supabaseClient
        self.language = language
    }
    
    func getAds(
        newerThan: Date?,
        orUpdatedAfter: Date?,
        limit: Int
    ) async throws -> [Ad] {
        var adsQuery = supabaseClient
            .from("ads")
            .select()
            .eq("language", value: language.rawValue)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let newerThan {
            let date = formatter.string(from: newerThan.addingTimeInterval(1))
            adsQuery = adsQuery
                .greaterThan("created_at", value: date)
        }
        if let orUpdatedAfter {
            let updateDate = formatter.string(from: orUpdatedAfter)
            adsQuery = adsQuery
                .greaterThan("updated_at", value: updateDate)
        }
        adsQuery = adsQuery.greaterThan(
            "expire_date",
            value: formatter.string(from: Date())
        )
        adsQuery = adsQuery.lowerThan(
            "begin_date",
            value: formatter.string(from: Date())
        )
        return try await adsQuery
            .order("created_at", ascending: false)
            .limit(limit)
            .execute()
            .value
    }
    
    func getAd(_ id: Ad.ID) async throws -> Ad? {
        fatalError("Not supported for remote repository")
    }
    
    func saveAd(_ ad: Ad) async throws {
        fatalError("Not supported for remote repository")
    }
    
    func saveAds(_ ads: [Ad]) async throws {
        fatalError("Not supported for remote repository")
    }
    
}
