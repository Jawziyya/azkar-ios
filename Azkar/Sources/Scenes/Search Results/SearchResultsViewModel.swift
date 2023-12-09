import SwiftUI
import Combine
import Library
import Entities

struct SearchResultZikr: Identifiable, Hashable {
    let id = UUID()
    var title: String?
    var text: String?
    var translation: String?
    var caption: String?
    var caption2: String?
    var footnote: String?
    let highlightText: String
    let zikr: Zikr
}

extension SearchResultZikr {
    
    private static func extractContextFrom(
        _ string: String?,
        query: String
    ) -> String? {
        guard let string else { return nil }
        return string
            .extractContext(query).reduce("", { $0 + "\n\n" + $1.context })
            .textOrNil
    }
    
    init(zikr: Zikr, query: String) {
        let titleMatches = SearchResultZikr.extractContextFrom(zikr.title, query: query)
        let textMatches = SearchResultZikr.extractContextFrom(zikr.text.trimmingArabicVowels, query: query.trimmingArabicVowels)
        let translationMatches = SearchResultZikr.extractContextFrom(zikr.translation, query: query)
        let sourceMatches = SearchResultZikr.extractContextFrom(zikr.source, query: query)
        let benefitsMatches = SearchResultZikr.extractContextFrom(zikr.benefits, query: query)
        let notesMatches = SearchResultZikr.extractContextFrom(zikr.notes, query: query)
        
        self.init(
            title: titleMatches,
            text: textMatches,
            translation: translationMatches,
            caption: sourceMatches,
            caption2: benefitsMatches,
            footnote: notesMatches,
            highlightText: query,
            zikr: zikr
        )
    }
}

struct SearchResultsSection: Identifiable {
    let id = UUID()
    let title: String?
    let results: [SearchResultZikr]
}

final class SearchResultsViewModel: ObservableObject {
    
    @Published var searchResults: [SearchResultsSection] = []
    @Published var selectedTokens: [SearchToken] = []
    @Published var isPerformingSearch = false
    
    private var morningAdhkar: [Zikr] = []
    private var eveningAdhkar: [Zikr] = []
    private var nightAdhkar: [Zikr] = []
    private var afterSalahAdhkar: [Zikr] = []
    private var otherAdhkar: [Zikr] = []
    
    private func getAdhkar(for token: SearchToken) -> [Zikr] {
        switch token {
        case .morning: return morningAdhkar
        case .evening: return eveningAdhkar
        case .night: return nightAdhkar
        case .afterSalah: return afterSalahAdhkar
        case .other: return otherAdhkar
        }
    }
    
    var haveSearchResults: Bool {
        searchResults.isEmpty == false
    }
    
    private let azkarDatabase: AzkarDatabase
    
    init(
        azkarDatabase: AzkarDatabase,
        searchTokens: AnyPublisher<[SearchToken], Never>,
        searchQuery: AnyPublisher<String, Never>
    ) {
        self.azkarDatabase = azkarDatabase
        searchTokens.assign(to: &$selectedTokens)
        searchQuery.map { _ in [] }.assign(to: &$searchResults)
        configureSearch(
            query: searchQuery,
            tokens: searchTokens,
            azkarDatabase: azkarDatabase,
        )
        
        do {
            morningAdhkar = try azkarDatabase.getAdhkar(.morning)
            eveningAdhkar = try azkarDatabase.getAdhkar(.evening)
            nightAdhkar = try azkarDatabase.getAdhkar(.night)
            afterSalahAdhkar = try azkarDatabase.getAdhkar(.afterSalah)
            otherAdhkar = try azkarDatabase.getAdhkar(.other)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func configureSearch(
        query: AnyPublisher<String, Never>,
        tokens: AnyPublisher<[SearchToken], Never>,
        azkarDatabase: AzkarDatabase,
    ) {
        let searchResults = query.combineLatest(tokens)
            .debounce(
                for: .seconds(1),
                scheduler: DispatchQueue.main
            )
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .flatMap(maxPublishers: .max(1)) { [unowned self] query, tokens -> AnyPublisher<[SearchResultsSection], Never> in
                guard let query = query.textOrNil, query.count >= 3 else {
                    return Just([]).eraseToAnyPublisher()
                }
                
                let searchTokens = tokens.isEmpty ? SearchToken.allCases : tokens
                let sections = searchTokens.compactMap { token -> SearchResultsSection? in
                    let azkar = getAdhkar(for: token)
                    let searchResults = peformSearchIn(azkar, query: query)
                    guard searchResults.isEmpty == false else {
                        return nil
                    }
                    return SearchResultsSection(title: token.title, results: searchResults)
                }
                return Just(sections).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
        
        searchResults.assign(to: &$searchResults)
        
        Publishers.Merge(
            query.map { _ in true },
            searchResults.map { _ in false }
        )
        .assign(to: &$isPerformingSearch)
    }
    
    private func peformSearchIn(_ azkar: [Zikr], query: String) -> [SearchResultZikr] {
        let normalizedQuery = query.lowercased()
        return azkar.compactMap { zikr -> SearchResultZikr? in
            let titleMatches = zikr.title?.lowercased().contains(normalizedQuery) == true
            let textMatches = zikr.text.trimmingArabicVowels.contains(query) == true
            let translationMatches = zikr.translation?.lowercased().contains(normalizedQuery) == true
            let sourceMatches = zikr.source.lowercased().contains(normalizedQuery)
            let benefitMatches = zikr.benefits?.lowercased().contains(normalizedQuery) == true
            let notesMatches = zikr.notes?.lowercased().contains(normalizedQuery) == true
            guard titleMatches || textMatches || translationMatches || sourceMatches || benefitMatches || notesMatches else {
                return nil
            }
            return SearchResultZikr(zikr: zikr, query: query)
        }
    }
    
}

extension SearchResultsViewModel {
    static var placeholder: SearchResultsViewModel {
        let vm = SearchResultsViewModel(
            azkarDatabase: .init(language: Language.english),
            searchTokens: Empty().eraseToAnyPublisher(),
            searchQuery: Empty().eraseToAnyPublisher()
        )
        vm.searchResults = [
            .init(title: "Placeholder", results: [
                SearchResultZikr(zikr: .placeholder(id: 1), query: "title"),
                SearchResultZikr(zikr: .placeholder(id: 2), query: "translation"),
                SearchResultZikr(zikr: .placeholder(id: 3), query: "notes"),
            ])
        ]
        return vm
    }
}
