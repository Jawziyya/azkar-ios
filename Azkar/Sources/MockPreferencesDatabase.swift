import Foundation
import Entities
import Library
import Fakery

final class MockPreferencesDatabase: PreferencesDatabase {
    
    init() {
        let faker = Faker()
        searchQueries = Array(0 ... Int.random(in: 1...10))
            .map { _ in
                faker.lorem.word()
            }
    }
    
    private var searchQueries: [String] = []
    private var openedZikr: [RecentZikr] = []
    
    func storeSearchQuery(_ query: String) async { 
        searchQueries.append(query)
    }
    
    func clearSearchQueries() async {
        searchQueries.removeAll()
    }
    
    func deleteSearchQuery(_ query: String) async {
        if let index = searchQueries.firstIndex(of: query) {
            searchQueries.remove(at: index)
        }
    }
    
    func getRecentSearchQueries(limit: UInt8) async -> [String] {
        return Array(searchQueries.prefix(upTo: Int(limit)))
    }
    
    func storeOpenedZikr(_ id: Zikr.ID, language: Language) async {
        let record = RecentZikr(zikrId: id, date: Date(), language: language)
        await deleteRecentZikr(id, language: language)
        openedZikr.insert(record, at: 0)
    }
    
    func deleteRecentZikr(_ id: Zikr.ID, language: Language) async {
        if let existingRecordIndex = openedZikr.firstIndex(where: { $0.id == id && $0.language == language }) {
            openedZikr.remove(at: existingRecordIndex)
        }
    }
    
    func getRecentAzkar(limit: UInt8) async -> [RecentZikr] {
        return Array(openedZikr.prefix(upTo: Int(limit)))
    }
    
    func clearRecentAzkar() async {
        openedZikr.removeAll()
    }
    
}
