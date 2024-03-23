import UIKit
import SwiftUI
import Coordinator
import Combine
import Stinsen
import WhatsNewKit
import MessageUI
import IGStoryKit
import Library
import ArticleReader
import Entities
import PDFKit

enum RootSection: Equatable, RouteKind {
    case category(ZikrCategory)
    case zikr(_ zikr: Zikr, index: Int? = nil)
    case searchResult(result: SearchResultZikr, searchQuery: String)
    case zikrPages(_ vm: ZikrPagesViewModel)
    case goToPage(Int)
    case settings(_ intitialRoute: SettingsRoute? = nil, presentModally: Bool = false)
    case aboutApp
    case whatsNew
    case shareOptions(Zikr)
    case article(Article)
}

final class RootCoordinator: NSObject, RouteTrigger, NavigationCoordinatable {
    
    var stack: Stinsen.NavigationStack<RootCoordinator> = .init(initial: \.root)
    
    @Root var root = makeRootView
    @Route(.push) var zikrCategory = makeCategoryView
    @Route(.push) var zikrPages = makeZikrPagesView
    @Route(.push) var zikr = makeZikrView
    @Route(.push) var azkarList = makeAzkarListView
    @Route(.push) var appInfo = makeAppInfoView
    @Route(.push) var settings = makeSettingsView
    @Route(.modal) var modalSettings = makeModalSettingsView
    @Route(.modal) var whatsNew = makeWhatsNewView
    @Route(.modal) var shareOptions = makeShareOptionsView
    @Route(.push) var articleView = makeArticleView
    
    let preferences: Preferences
    var databaseService: AzkarDatabase {
        AzkarDatabase(language: preferences.contentLanguage)
    }
    let preferencesDatabase: PreferencesDatabase
    let deeplinker: Deeplinker
    let player: Player
    let articlesService: ArticlesServiceType

    private let selectedZikrPageIndex = CurrentValueSubject<Int, Never>(0)

    private var cancellables = Set<AnyCancellable>()
    
    private var childCoordinators: [any Identifiable] = []
    
    private var section: RootSection? {
        didSet {
            guard let section else { return }
            DispatchQueue.main.async {
                self.handleSelection(section)
            }
        }
    }
    
    init(
        preferences: Preferences,
        deeplinker: Deeplinker,
        player: Player
    ) {
        self.preferences = preferences
        self.deeplinker = deeplinker
        self.player = player
        
        let appGroupFolder = FileManager.default
            .appGroupContainerURL
        
        articlesService = ArticlesService(
            databasePath: appGroupFolder
                .appendingPathComponent("articles.db")
                .absoluteString,
            language: preferences.contentLanguage.fallbackLanguage
        )
        
        let preferencesDatabasePath = appGroupFolder
            .appendingPathComponent("preferences.db")
            .absoluteString
        preferencesDatabase = PreferencesSQLiteDatabaseService(databasePath: preferencesDatabasePath)
        
        super.init()
        
        preferences.$colorTheme
            .receive(on: RunLoop.main)
            .prepend(preferences.colorTheme)
            .sink(receiveValue: { _ in
                let color = UIColor(Color.accent)
                UINavigationBar.appearance().tintColor = color
            })
            .store(in: &cancellables)

        deeplinker
            .$route
            .sink(receiveValue: { [unowned self] route in
                switch route {

                case .settings(let section):
                    self.trigger(.settings(section))

                case .azkar(let category):
                    self.trigger(.category(category))

                default:
                    break

                }
            })
            .store(in: &cancellables)
    }
    
    func azkarForCategory(_ category: ZikrCategory) -> [ZikrViewModel] {
        do {
            let adhkar = try databaseService.getAdhkar(category)
            let viewModels = try adhkar.enumerated().map { idx, zikr in
                try ZikrViewModel(
                    zikr: zikr,
                    isNested: true,
                    row: idx + 1,
                    hadith: zikr.hadith.flatMap { id in
                        try databaseService.getHadith(id)
                    },
                    preferences: preferences,
                    player: player
                )
            }
            return viewModels
        } catch {
            return []
        }
    }

    func trigger(_ route: RootSection) {
        section = route
    }

    func goToSettings() {
        section = .settings()
    }
    
}

private extension RootCoordinator {

    func handleSelection(_ section: RootSection) {
        
        let rootViewController = UINavigationController()
        
        switch section {
        case .aboutApp, .category, .settings:
            selectedZikrPageIndex.send(0)
        case .zikr, .zikrPages, .goToPage, .whatsNew, .shareOptions, .searchResult, .article:
            break
        }
        
        switch section {

        case .category(let category):
            if category == .other {
                route(to: \.azkarList, category)
            } else {
                route(to: \.zikrCategory, category)
            }
            
        case .article(let article):
            route(to: \.articleView, article)
            Task {
                await self.articlesService.sendAnalyticsEvent(.view, articleId: article.id)
            }

        case .zikrPages(let vm):
            route(to: \.zikrPages, vm)
            
        case .searchResult(let searchResult, let query):
            guard let zikr = try? databaseService.getZikr(searchResult.zikrId, language: searchResult.language) else {
                return
            }
            
            Task {
                await preferencesDatabase.storeOpenedZikr(zikr.id, language: zikr.language)
            }
            
            let hadith = try? zikr.hadith.flatMap { id in
                try databaseService.getHadith(id)
            }
            let viewModel = ZikrViewModel(
                zikr: zikr,
                isNested: false,
                highlightPattern: query,
                hadith: hadith,
                preferences: preferences,
                player: player
            )
            route(to: \.zikr, viewModel)

        case .zikr(let zikr, let index):
            assert(Thread.isMainThread)
            if let index = index, rootViewController.isPadInterface {
                self.selectedZikrPageIndex.send(index)
                return
            }
            
            Task {
                await preferencesDatabase.storeOpenedZikr(zikr.id, language: zikr.language)
            }

            let hadith = try? zikr.hadith.flatMap { id in
                try databaseService.getHadith(id)
            }
            let viewModel = ZikrViewModel(
                zikr: zikr,
                isNested: true,
                hadith: hadith,
                preferences: preferences,
                player: player
            )
            route(to: \.zikr, viewModel)

        case .goToPage(let page):
            selectedZikrPageIndex.send(page)
            
        case .settings(let initialRoute, let presentModally):
            if presentModally {
                route(to: \.modalSettings, initialRoute)
            } else {
                route(to: \.settings, initialRoute)
            }

        case .aboutApp:
            route(to: \.appInfo)
            
        case .whatsNew:
            guard let whatsNew = getWhatsNew() else {
                return
            }
            route(to: \.whatsNew, whatsNew)
            
        case .shareOptions(let zikr):
            route(to: \.shareOptions, zikr)

        }
    }

}

extension RootCoordinator {
    
    func makeRootView() -> some View {
        RootView(
            viewModel: RootViewModel(
                mainMenuViewModel: MainMenuViewModel(
                    databaseService: databaseService,
                    preferencesDatabase: preferencesDatabase,
                    router: UnownedRouteTrigger(router: self),
                    preferences: preferences,
                    player: player,
                    articlesService: articlesService
                )
            )
        )
    }
    
    func makeArticleView(_ article: Article) -> some View {
        ArticleScreen(
            viewModel: ArticleViewModel(article: article),
            onShareButtonTap: {
                assert(Thread.isMainThread)
                guard
                    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = scene.windows.first,
                    let rootViewController = window.rootViewController?.topmostPresentedViewController
                else {
                    return
                }
                
                let view = ArticleScreen(
                    viewModel: ArticleViewModel(article: article),
                    shareOptions: .init(maxWidth: UIScreen.main.bounds.width)
                )
                .padding(30)
                .frame(width: UIScreen.main.bounds.width)
                .frame(maxHeight: .infinity)
                .environment(\.colorScheme, .light)
                .background(Color.white)
                
                let viewController = UIHostingController(rootView: view)
                
                let image = viewController.snapshot()
                
                let pdfDocument = PDFDocument()
                guard let pdfPage = PDFPage(image: image) else {
                    return
                }
                pdfDocument.insert(pdfPage, at: 0)
                guard let data = pdfDocument.dataRepresentation() else {
                    return
                }
                
                let fileName = "\(article.title).pdf"
                let tempFilePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                
                do {
                    try? FileManager.default.removeItem(at: tempFilePath)
                    try data.write(to: tempFilePath)
                } catch {
                    return
                }
                
                let activityController = UIActivityViewController(
                    activityItems: [tempFilePath],
                    applicationActivities: [ZikrFeedbackActivity(prepareAction: { [unowned self] in
                        self.presentMailComposer(from: viewController)
                    })]
                )
                activityController.excludedActivityTypes = [
                    .init(rawValue: "com.apple.reminders.sharingextension")
                ]
                activityController.completionWithItemsHandler = { [unowned self] (activityType, completed, arguments, error) in
                    viewController.dismiss()
                    if completed {
                        Task {
                            await self.articlesService.sendAnalyticsEvent(.share, articleId: article.id)
                        }
                    }
                }
                rootViewController.present(activityController, animated: true)
            }
        )
    }
    
    func makeZikrPagesViewModel(_ category: ZikrCategory) -> ZikrPagesViewModel {
        return ZikrPagesViewModel(
            router: UnownedRouteTrigger(router: self),
            category: category,
            title: category.title,
            azkar: azkarForCategory(category),
            preferences: preferences,
            selectedPagePublisher: selectedZikrPageIndex.removeDuplicates().eraseToAnyPublisher(),
            initialPage: selectedZikrPageIndex.value
        )
    }
    
    func makeCategoryView(_ category: ZikrCategory) -> ZikrPagesView {
        let viewModel = makeZikrPagesViewModel(category)
        return ZikrPagesView(viewModel: viewModel)
    }
    
    func makeAzkarListView(_ category: ZikrCategory) -> some View {
        let viewModel = makeZikrPagesViewModel(category)
        return AzkarListView(viewModel: viewModel)
    }
    
    func makeZikrPagesView(_ viewModel: ZikrPagesViewModel) -> some View {
        ZikrPagesView(viewModel: viewModel)
    }
    
    func makeZikrView(_ viewModel: ZikrViewModel) -> some View {
        ZikrPagesView(
            viewModel: ZikrPagesViewModel(
                router: UnownedRouteTrigger(router: self),
                category: .other,
                title: "",
                azkar: [viewModel],
                preferences: preferences,
                selectedPagePublisher: Empty().eraseToAnyPublisher(),
                initialPage: 0
            )
        )
    }
    
    func makeAppInfoView() -> some View {
        AppInfoView(viewModel: AppInfoViewModel(preferences: preferences))
    }
    
    func makeSettingsView(_ initialRoute: SettingsRoute?) -> SettingsCoordinator {
        SettingsCoordinator(
            databaseService: databaseService,
            preferences: preferences,
            initialRoute: initialRoute
        )
    }
    
    func makeModalSettingsView(_ initialRoute: SettingsRoute?) -> NavigationViewCoordinator<SettingsCoordinator> {
        NavigationViewCoordinator(
            SettingsCoordinator(
                databaseService: databaseService,
                preferences: preferences,
                initialRoute: initialRoute
            )
        )
    }
    
    func makeWhatsNewView(_ whatsNew: WhatsNew) -> some View {
        getWhatsNewView(whatsNew)
    }
    
    func makeShareOptionsView(zikr: Zikr) -> some View {
        ZikrShareOptionsView(zikr: zikr) { [unowned self] options in
            assert(Thread.isMainThread)
            guard
                let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = scene.windows.first,
                let rootViewController = window.rootViewController?.topmostPresentedViewController
            else {
                return
            }
            self.share(zikr: zikr, options: options, from: rootViewController)
        }
        .tint(Color.accent)
    }
    
}

extension RootCoordinator: MFMailComposeViewControllerDelegate {
    
    private func share(
        zikr: Zikr,
        options: ZikrShareOptionsView.ShareOptions,
        from viewController: UIViewController
    ) {
        let currentViewModel = ZikrViewModel(zikr: zikr, isNested: true, hadith: nil, preferences: preferences, player: player)
        let activityItems: [Any]

        switch options.shareType {

        case .image, .instagramStories:

            let view = ZikrShareView(
                viewModel: currentViewModel,
                includeTitle: options.includeTitle,
                includeTranslation: preferences.expandTranslation,
                includeTransliteration: preferences.expandTransliteration,
                includeBenefits: options.includeBenefits,
                includeLogo: options.includeLogo,
                arabicTextAlignment: options.textAlignment.isCentered ? .center : .trailing,
                otherTextAlignment: options.textAlignment.isCentered ? .center : .leading,
                useFullScreen: options.shareType == .image
            )
            .environment(\.colorScheme, .light)
            .preferredColorScheme(.light)
            .frame(width: UIScreen.main.bounds.width)
            .frame(maxHeight: .infinity)
            let image = view.snapshot()

            if options.shareType == .image {
                let tempDir = FileManager.default.temporaryDirectory
                let imgFileName = "\(currentViewModel.title).png"
                let tempImagePath = tempDir.appendingPathComponent(imgFileName)
                try? image.pngData()?.write(to: tempImagePath)
                activityItems = [tempImagePath]
            } else if options.shareType == .instagramStories {
                let story = IGStory(contentSticker: image, background: .color(color: UIColor(Color.background)))
                let dispatcher = IGDispatcher(story: story, facebookAppID: "n/a")
                dispatcher.start()
                return
            } else {
                return
            }

        case .text:
            let text = currentViewModel.getShareText(
                includeTitle: options.includeTitle,
                includeTranslation: preferences.expandTranslation,
                includeTransliteration: preferences.expandTransliteration,
                includeBenefits: options.includeBenefits
            )
            activityItems = [text]

        }

        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: [ZikrFeedbackActivity(prepareAction: { [unowned self] in
                self.presentMailComposer(from: viewController)
            })]
        )
        activityController.excludedActivityTypes = [
            .init(rawValue: "com.apple.reminders.sharingextension")
        ]
        activityController.completionWithItemsHandler = { (activityType, completed, arguments, error) in
            guard completed else {
                return
            }
            viewController.dismiss()
        }
        viewController.present(activityController, animated: true)
    }
    
    private func presentMailComposer(from viewController: UIViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            UIApplication.shared.open(URL(string: "https://t.me/jawziyya_feedback")!)
            return
        }
        let mailComposerViewController = MFMailComposeViewController()
        mailComposerViewController.setToRecipients(["azkar.app@pm.me"])
        mailComposerViewController.mailComposeDelegate = self
        viewController.present(mailComposerViewController, animated: true)
    }
    
}
