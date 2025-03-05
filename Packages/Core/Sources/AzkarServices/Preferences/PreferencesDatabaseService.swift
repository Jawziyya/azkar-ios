import Foundation
import Entities

public protocol PreferencesDatabaseService {
    
    /// Save search query in database.
    func storeSearchQuery(_ query: String) async
    
    /// Remove search query from database.
    func deleteSearchQuery(_ query: String) async
    
    /// Clear all search queries.
    func clearSearchQueries() async
    
    /// Get list of recently performed searches.
    func getRecentSearchQueries(limit: UInt8) async -> [String]
        
    /// Save metadata of opened zikr along with its language.
    func storeOpenedZikr(_ id: Zikr.ID, language: Language) async
    
    /// Retrieve list of recently opened azkar.
    func getRecentAzkar(limit: UInt8) async -> [RecentZikr]
    
    /// Remove zikr from recent azkar list.
    func deleteRecentZikr(_ id: Zikr.ID, language: Language) async
    
    /// Clear recently opened azkar list.
    func clearRecentAzkar() async
    
}
