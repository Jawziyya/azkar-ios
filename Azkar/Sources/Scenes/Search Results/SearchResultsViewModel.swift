import SwiftUI
import Combine
import Library
import Entities

struct SearchResult: Identifiable {
    let id = UUID()
    let title: String?
    let text: String
    let resultType: ResultType
    
    enum ResultType {
        case category(ZikrCategory), zikr(Zikr)
    }
}

struct SearchResultsSection: Identifiable {
    let id = UUID()
    let title: String
    let results: [SearchResult]
}

final class SearchResultsViewModel: ObservableObject {
    
    @Published var sections: [SearchResultsSection] = []
    @Published var isPerformingSearch = false
    
    private let categoriesSection = PassthroughSubject<[SearchResultsSection], Never>()
    private let azkarSection = PassthroughSubject<[SearchResultsSection], Never>()
    
    var haveSearchResults: Bool {
        return sections.contains { !$0.results.isEmpty }
    }
    
    private let databaseService: DatabaseService
    
    init(
        databaseService: DatabaseService,
        searchQuery: AnyPublisher<String, Never>
    ) {
        self.databaseService = databaseService
        searchQuery.map { _ in [] }.assign(to: &$sections)
        configureSearch(query: searchQuery, databaseService: databaseService)
    }
    
    private func configureSearch(
        query: AnyPublisher<String, Never>,
        databaseService: DatabaseService
    ) {
        let categoriesSection = query
            .map { query -> [ZikrCategory] in
                return [ZikrCategory.morning, .evening, .night, .afterSalah, .other]
                    .filter { $0.title.contains(query) || $0.title.contains(query.lowercased()) }
            }
            .map { categories in
                SearchResultsSection(title: "Categories", results: categories.map { category in
                    SearchResult(
                        title: nil,
                        text: category.title,
                        resultType: .category(category)
                    )
                })
            }
        
        let azkarSection = query
            .throttle(
                for: .seconds(1),
                scheduler: DispatchQueue.main,
                latest: true
            )
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .flatMap { query -> AnyPublisher<[SearchResult], Never> in
                do {
                    let azkar = try databaseService.searchAdhkar(query)
                    let results = azkar.map { zikr in
                        let title = zikr.title ?? ""
                        let text = (zikr.translation ?? "")
                        let context = text.extractContext(query)
                            .first ?? ""
                        return SearchResult(
                            title: context.isEmpty ? nil : title.textOrNil,
                            text: context.isEmpty ? title : context,
                            resultType: .zikr(zikr)
                        )
                    }
                    return Just(results).eraseToAnyPublisher()
                } catch {
                    return Just([]).eraseToAnyPublisher()
                }
            }
            .map { results in
                return SearchResultsSection(title: "Azkar", results: results)
            }
            .receive(on: DispatchQueue.main)
        
        Publishers
            .CombineLatest(categoriesSection.prepend([]), azkarSection.prepend([]))
            .map { [$0, $1] }
            .assign(to: &$sections)
        
        Publishers.Merge(
            query.map { _ in true },
            azkarSection.map { _ in false }
        )
        .assign(to: &$isPerformingSearch)
    }
    
}

extension SearchResultsViewModel {
    static var placeholder: SearchResultsViewModel {
        let vm = SearchResultsViewModel(
            databaseService: .init(language: Language.english),
            searchQuery: Empty().eraseToAnyPublisher()
        )
        vm.sections = [
            .init(title: "Categories", results: [
                SearchResult(title: nil, text: "Morning", resultType: .category(.morning)),
                SearchResult(title: nil, text: "Evening", resultType: .category(.evening)),
            ]),
            .init(title: "Azkar", results: [
                SearchResult(title: "Zikr title 1", text: "Zikr text 1", resultType: .zikr(.placeholder)),
                SearchResult(title: "Zikr title 2", text: "Zikr text 2", resultType: .zikr(.placeholder)),
                SearchResult(title: "Zikr title 3", text: "Zikr text 3", resultType: .zikr(.placeholder)),
            ]),
        ]
        return vm
    }
}
