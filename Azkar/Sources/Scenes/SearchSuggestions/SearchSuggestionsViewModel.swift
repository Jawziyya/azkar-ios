import SwiftUI
import Combine
import Entities
import Library

final class SearchSuggestionsViewModel: ObservableObject {
    
    @Published var presentSuggestions = false
    @Published var suggestedQueries: [String] = []
    @Published var suggestedAzkar: [Zikr] = []
    
    private let router: UnownedRouteTrigger<RootSection>
    private let azkarDatabase: AzkarDatabase
    private let preferencesDatabase: PreferencesDatabase
    
    init(
        searchQuery: AnyPublisher<String, Never>,
        azkarDatabase: AzkarDatabase,
        preferencesDatabase: PreferencesDatabase,
        router: UnownedRouteTrigger<RootSection>
    ) {
        self.azkarDatabase = azkarDatabase
        self.preferencesDatabase = preferencesDatabase
        self.router = router
        
        Task {
            await loadSuggestions()
        }
    }
    
    func getAvailableLanguages() -> [Language] {
        Language.allCases.filter(azkarDatabase.translationExists(for:))
    }
    
    static var placeholder: SearchSuggestionsViewModel {
        SearchSuggestionsViewModel(
            searchQuery: Empty().eraseToAnyPublisher(),
            azkarDatabase: AdhkarSQLiteDatabaseService(language: Language.english),
            preferencesDatabase: MockPreferencesDatabase(),
            router: .empty
        )
    }
    
    @MainActor func loadSuggestions() async {
        suggestedQueries = await preferencesDatabase.getRecentSearchQueries(limit: 5)
        do {
            suggestedAzkar = try await preferencesDatabase.getRecentAzkar(limit: 5)
                .compactMap { record -> Zikr? in
                    try azkarDatabase.getZikr(record.zikrId, language: record.language)
                }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func navigateToZikr(_ zikr: Zikr) {
        router.trigger(.searchResult(result: .init(zikr: zikr, query: ""), searchQuery: ""))
    }
    
    func removeRecentQueries(at indexSet: IndexSet) async {
        for index in indexSet {
            let query = suggestedQueries.remove(at: index)
            await preferencesDatabase.deleteSearchQuery(query)
        }
    }
    
    func clearRecentQueries() {
        suggestedQueries = []
        Task {
            await preferencesDatabase.clearSearchQueries()
        }
    }
    
    func removeRecentAzkar(at indexSet: IndexSet) async {
        for index in indexSet {
            let zikr = suggestedAzkar.remove(at: index)
            await preferencesDatabase.deleteRecentZikr(zikr.id, language: zikr.language)
        }
    }
    
    func clearRecentAzkar() {
        suggestedAzkar = []
        Task {
            await preferencesDatabase.clearRecentAzkar()
        }
    }
    
}
