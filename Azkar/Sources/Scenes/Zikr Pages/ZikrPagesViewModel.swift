import SwiftUI
import Combine
import Library
import AzkarServices
import Entities

final class ZikrPagesViewModel: ObservableObject, Equatable {
    
    enum PageType: Hashable, Identifiable {
        var id: String {
            switch self {
            case .zikr(let vm): return vm.id.description
            case .readingCompletion: return "readingCompletion"
            }
        }
        
        case zikr(ZikrViewModel)
        case readingCompletion
    }

    static func == (lhs: ZikrPagesViewModel, rhs: ZikrPagesViewModel) -> Bool {
        lhs.category == rhs.category && lhs.title == rhs.title
    }
    
    let router: UnownedRouteTrigger<RootSection>
    let category: ZikrCategory
    let title: String
    let azkar: [ZikrViewModel]
    let pages: [PageType]
    let preferences: Preferences
    let selectedPage: AnyPublisher<Int, Never>
    let initialPage: Int
    let zikrCounter: ZikrCounterType = ZikrCounter.shared
    
    @Published var page = 0
    @Published var hasRemainingRepeats = true
    @Published var counterPosition: CounterPosition

    @Published var isCategoryCompleted = false

    private var cancellables = Set<AnyCancellable>()

    init(
        router: UnownedRouteTrigger<RootSection>,
        category: ZikrCategory,
        title: String,
        azkar: [ZikrViewModel],
        preferences: Preferences,
        selectedPagePublisher: AnyPublisher<Int, Never>,
        initialPage: Int
    ) {
        self.router = router
        self.category = category
        self.title = title
        self.preferences = preferences
        self.azkar = azkar
        self.selectedPage = selectedPagePublisher
        self.initialPage = initialPage
        self.page = initialPage
        counterPosition = preferences.counterPosition
        
        var pages = azkar.map { PageType.zikr($0) }
        if category != .other {
            pages.append(.readingCompletion)
        }
        self.pages = pages
        
        // Setup completion tracking if category is not 'other'
        if category != .other {
            Task { [weak self] in
                await self?.setupCompletionTracking()
            }
        }

        preferences
            .$counterType
            .toVoid()
            .sink(receiveValue: objectWillChange.send)
            .store(in: &cancellables)
        
        selectedPagePublisher.dropFirst().assign(to: &$page)
    }
    
    /// Sets up tracking for category completion status
    /// Checks if category is already marked as completed and observes completion status changes
    private func setupCompletionTracking() async {
        if category == .afterSalah {
            await zikrCounter.resetCounterForCategory(category)
        }
        
        @Sendable func setHasRemainingRepeats(_ flag: Bool) {
            withAnimation(.smooth) {
                self.hasRemainingRepeats = flag
            }
        }
        
        // Check if category is already marked as completed
        let isCategoryCompleted = await zikrCounter.isCategoryMarkedAsCompleted(category)
        await MainActor.run {
            setHasRemainingRepeats(!isCategoryCompleted)
        }

        guard !isCategoryCompleted else {
            return
        }
        
        // Set up observation for completed repeats
        let totalCount = azkar.reduce(0) { $0 + $1.zikr.repeats }
        zikrCounter.observeCompletedRepeats(in: category)
            .receive(on: DispatchQueue.main)
            .sink { count in
                setHasRemainingRepeats(count < totalCount)
            }
            .store(in: &cancellables)
    }

    func navigateToZikr(_ vm: ZikrViewModel, index: Int) {
        if UIDevice.current.isIpadInterface {
            router.trigger(.zikr(vm.zikr, index: index))
        } else {
            router.trigger(RootSection.zikrPages(ZikrPagesViewModel(
                router: router,
                category: category,
                title: title,
                azkar: azkar,
                preferences: preferences,
                selectedPagePublisher: selectedPage.eraseToAnyPublisher(),
                initialPage: index
            )))
        }
    }
    
    func navigateToTextSettings() {
        router.trigger(.settings(.text, presentModally: true))
    }

    func goToNextZikrIfNeeded() {
        let newIndex = page + 1
        guard preferences.enableGoToNextZikrOnCounterFinished, newIndex < pages.count else {
            return
        }
        router.trigger(.goToPage(newIndex))
    }
    
    static var placeholder: ZikrPagesViewModel {
        AzkarListViewModel(
            router: .empty,
            category: .other,
            title: ZikrCategory.morning.title,
            azkar: [.demo()],
            preferences: Preferences.shared,
            selectedPagePublisher: PassthroughSubject<Int, Never>().eraseToAnyPublisher(),
            initialPage: 0
        )
    }
        
    func shareCurrentZikr() {
        guard azkar.count > page else {
            return
        }
        let zikr = azkar[page].zikr
        router.trigger(.shareOptions(zikr))
    }
        
    @MainActor func markCurrentCategoryAsCompleted() async {
        try? await zikrCounter.markCategoryAsCompleted(category)
        hasRemainingRepeats = false
    }

}
