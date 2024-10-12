import SwiftUI
import AudioPlayer
import Combine
import Entities
import Fakery
import ArticleReader
import Library

typealias SearchToken = ZikrCategory

final class MainMenuViewModel: ObservableObject {

    @Published var searchQuery = ""
    @Published var searchTokens: [SearchToken] = []
    @Published var availableSearchTokens: [SearchToken] = SearchToken.allCases
    
    private let searchQueryPublisher = CurrentValueSubject<String, Never>("")

    let router: UnownedRouteTrigger<RootSection>
    let azkarDatabase: AzkarDatabase
    let preferencesDatabase: PreferencesDatabase
    
    private(set) lazy var searchViewModel = SearchResultsViewModel(
        azkarDatabase: azkarDatabase,
        preferencesDatabase: preferencesDatabase,
        searchTokens: $searchTokens.eraseToAnyPublisher(),
        searchQuery: searchQueryPublisher.removeDuplicates().eraseToAnyPublisher()
    )
    
    private(set) lazy var searchSuggestionsViewModel = SearchSuggestionsViewModel(
        searchQuery: $searchQuery.removeDuplicates().eraseToAnyPublisher(),
        azkarDatabase: azkarDatabase,
        preferencesDatabase: preferencesDatabase,
        router: router
    )

    let currentYear: String
    
    let otherAzkarModels: [AzkarMenuItem]
    
    @Published var fadl: Fadl?

    @Published var additionalMenuItems: [AzkarMenuOtherItem] = []
    @Published var enableEidBackground = false
    @Published var articles: [Article] = []
    @Published var ad: Ad?

    @Preference("kDidDisplayIconPacksMessage", defaultValue: false)
    var didDisplayIconPacksMessage

    let player: Player
    private(set) var additionalAdhkar: [ZikrMenuItem]?

    let preferences: Preferences
    private let articlesService: ArticlesServiceType
    private let adsService: AdsServiceType

    private var cancellables = Set<AnyCancellable>()

    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    private lazy var iconsPackMessage: AzkarMenuOtherItem = {
        let title = L10n.Alerts.checkoutIconPacks
        var item = AzkarMenuOtherItem(imageName: AppIconPack.maccinz.icons.randomElement()!.imageName, title: title, color: Color.red, iconType: .bundled, imageCornerRadius: 4)
        item.action = { [unowned self] in
            self.didDisplayIconPacksMessage = true
            self.navigateToIconPacksList()
        }
        return item
    }()

    init(
        databaseService: AzkarDatabase,
        preferencesDatabase: PreferencesDatabase,
        router: UnownedRouteTrigger<RootSection>,
        preferences: Preferences,
        player: Player,
        articlesService: ArticlesServiceType,
        adsService: AdsServiceType
    ) {
        self.azkarDatabase = databaseService
        self.preferencesDatabase = preferencesDatabase
        self.router = router
        self.preferences = preferences
        self.player = player
        self.articlesService = articlesService
        self.adsService = adsService
        
        if Date().isRamadan {
            var adhkar: [ZikrMenuItem] = []
            if let fastindDua = databaseService.getZikrBeforeBreakingFast() {
                adhkar.append(ZikrMenuItem(
                    color: Color.blue,
                    iconType: IconType.emoji,
                    imageName: "🥛",
                    zikr: fastindDua
                ))
            }
            if let laylatulQadrDua = databaseService.getLaylatulQadrDua() {
                adhkar.append(ZikrMenuItem(
                    color: Color.green,
                    iconType: IconType.emoji,
                    imageName: "🌕",
                    zikr: laylatulQadrDua
                ))
            }
            additionalAdhkar = adhkar
        }
        
        otherAzkarModels = [
            AzkarMenuItem(
                category: .night,
                imageName: "bed.double.circle.fill",
                title: L10n.Category.night,
                color: Color.init(uiColor: .systemMint),
                count: nil
            ),
            AzkarMenuItem(
                category: .afterSalah,
                imageName: "mosque",
                title: L10n.Category.afterSalah,
                color: Color.init(.systemBlue),
                count: nil,
                iconType: .bundled
            ),
            AzkarMenuItem(
                category: .other,
                imageName: "square.stack.3d.down.right.fill",
                title: L10n.Category.other,
                color: Color.init(.systemTeal),
                count: nil
            ),
        ]
        
        var year = "\(Date().hijriYear) г.х."
        switch Calendar.current.identifier {
        case .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura:
            break
        default:
            year += " (\(Date().year) г.)"
        }
        currentYear = year

        preferences.$enableFunFeatures
            .map { flag in flag && Date().isRamadanEidDays }
            .assign(to: \.enableEidBackground, on: self)
            .store(in: &cancellables)
        
        preferences
            .storageChangesPublisher()
            .receive(on: RunLoop.main)
            .sink { [unowned self] in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        preferences
            .$contentLanguage
            .handleEvents(receiveOutput: { language in
                ArticleCategory.language = language
            })
            .map { language in
                try? databaseService.getRandomFadl(language: language)
            }
            .assign(to: &$fadl)
        
        $searchQuery
            .removeDuplicates()
            .subscribe(on: DispatchQueue.global(qos: .userInteractive))
            .subscribe(searchQueryPublisher)
            .store(in: &cancellables)
        
        Task {
            await loadArticles()
        }
        
        Task {
            await loadAds()
        }
    }
    
    private func loadArticles() async {
        do {
            for try await articles in articlesService.getArticles(
                limit: 5
            ) {
                await MainActor.run {
                    withAnimation {                    
                        self.articles = articles
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor private func loadAds() async {
        do {
            let ads = try await adsService.fetchAds(newerThan: nil)
            self.ad = ads.last
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func navigateToArticle(_ article: Article) {
        router.trigger(.article(article))
    }
    
    func naviateToSearchResult(_ searchResult: SearchResultZikr) {
        router.trigger(.searchResult(result: searchResult, searchQuery: searchQuery))
    }

    func navigateToZikr(_ zikr: Zikr) {
        router.trigger(.zikr(zikr))
    }

    func navigateToCategory(_ category: ZikrCategory) {
        router.trigger(.category(category))
    }

    func navigateToSettings() {
        router.trigger(.settings())
    }

    func navigateToIconPacksList() {
        router.trigger(.settings(.appearance))
    }
    
    func hideAd(_ ad: Ad) {
        self.ad = nil
    }
    
    func handleAdSelection(_ ad: Ad) {
        UIApplication.shared.open(ad.actionLink)
        adsService.sendAnalytics(for: ad, action: .open)
    }
    
    func sendAdImpressionEvent(_ ad: Ad) {
        adsService.sendAnalytics(for: ad, action: .impression)
    }
    
    let faker = Faker()
    
    func getSearchSuggestions() -> [String] {
        return [
            faker.lorem.word(),
            faker.lorem.word(),
            faker.lorem.word(),
            faker.lorem.word(),
            faker.lorem.word(),
        ]
    }

}

extension MainMenuViewModel {
    
    static var placeholder: MainMenuViewModel {
        MainMenuViewModel(
            databaseService: AzkarDatabase(language: Language.getSystemLanguage()),
            preferencesDatabase: MockPreferencesDatabase(),
            router: .empty,
            preferences: Preferences.shared,
            player: .test,
            articlesService: DemoArticlesService(),
            adsService: DemoAdsService()
        )
    }
    
}
