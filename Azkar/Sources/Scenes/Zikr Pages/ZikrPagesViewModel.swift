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
    let canUseCounter: Bool
    let initialPage: Int
    let zikrCounter: ZikrCounterType = ZikrCounter.shared
    
    @Published var page = 0
    @Published var currentZikrRemainingRepeatNumber = 0
    @Published var hasRemainingRepeats = true

    @Published var isCategoryCompleted = false
    private var incrementerPublishers: [ZikrViewModel: PassthroughSubject<Void, Never>] = [:]

    let alignZikrCounterByLeadingSide: Bool

    var showCounterButton: Bool {
        preferences.counterType == .floatingButton
    }

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
        canUseCounter = category != .other
        
        alignZikrCounterByLeadingSide = preferences.alignCounterButtonByLeadingSide
        
        pages = azkar.map { PageType.zikr($0) } + [.readingCompletion]

        azkar.forEach { vm in
            incrementerPublishers[vm] = PassthroughSubject<Void, Never>()
        }
        
        // Setup completion tracking if category is not 'other'
        if category != .other {
            Task { [weak self] in
                await self?.setupCompletionTracking()
            }
        }

        $page
            .delay(for: 0.25, scheduler: DispatchQueue.main)
            .map { [unowned self] page in
                guard page < self.azkar.count else {
                    return 0
                }
                let zikr = self.azkar[page]
                return zikr.remainingRepeatsNumber
            }
            .assign(to: &$currentZikrRemainingRepeatNumber)
   
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
            await zikrCounter.resetCategoryCompletionMark(.afterSalah)
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

    func setZikrCounterAlignment(byLeftSide flag: Bool) {
        preferences.alignCounterButtonByLeadingSide = flag
    }

    func incrementCurrentPageZikrCounter() {
        let zikr = azkar[page]
        incrementerPublishers[zikr]?.send()
        let number = zikr.remainingRepeatsNumber - 1
        currentZikrRemainingRepeatNumber = number
    }

    func getIncrementPublisher(for zikr: ZikrViewModel) -> AnyPublisher<Void, Never> {
        if let publisher = incrementerPublishers[zikr] {
            return publisher.eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
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
