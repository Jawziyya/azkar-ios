//
//
//  Azkar
//  
//  Created on 15.08.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import UIKit
import SwiftUI
import Coordinator
import Combine

enum RootSection: Equatable, Route {
    case root
    case category(ZikrCategory)
    case zikr(_ zikr: Zikr, index: Int? = nil)
    case zikrPages(_ vm: ZikrPagesViewModel)
    case goToPage(Int)
    case settings(_ intitialRoute: SettingsRoute? = nil, presentModally: Bool = false)
    case aboutApp
    case subscribe
    case whatsNew
}

final class RootCoordinator: NavigationCoordinator, RouteTrigger {
    
    typealias RouteType = RootSection

    let preferences: Preferences
    var databaseService: DatabaseService {
        DatabaseService(language: preferences.contentLanguage)
    }
    let deeplinker: Deeplinker
    let player: Player

    private let selectedZikrPageIndex = CurrentValueSubject<Int, Never>(0)

    private var cancellables = Set<AnyCancellable>()

    init(
        preferences: Preferences,
        deeplinker: Deeplinker,
        player: Player
    ) {
        self.preferences = preferences
        self.deeplinker = deeplinker
        self.player = player

        let navigationController = UINavigationController()
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.navigationBar.prefersLargeTitles = true

        super.init(rootViewController: navigationController)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.trigger(.whatsNew)
        }
        
        preferences.$colorTheme
            .receive(on: RunLoop.main)
            .prepend(preferences.colorTheme)
            .sink(receiveValue: { _ in
                let color = UIColor(Color.accent)
                navigationController.navigationBar.tintColor = color
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

    func azkarForCategory(_ category: ZikrCategory) throws -> [ZikrViewModel] {
        let adhkar = try databaseService.getAdhkar(category)
        let viewModels = try adhkar.enumerated().map { idx, zikr in
            try ZikrViewModel(
                zikr: zikr,
                row: idx + 1,
                hadith: zikr.hadith.flatMap { id in
                    try databaseService.getHadith(id)
                },
                preferences: preferences,
                player: player
            )
        }
        return viewModels
    }

    func trigger(_ route: RootSection) {
        section = route
    }

    private var section = RootSection.root {
        didSet {
            DispatchQueue.main.async {
                self.handleSelection(self.section)
            }
        }
    }

    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
        section = .root
    }

    func goToSettings() {
        section = .settings()
    }

}

private extension RootCoordinator {

    func handleSelection(_ section: RootSection) {
        switch section {
        case .aboutApp, .category, .root, .settings:
            selectedZikrPageIndex.send(0)
        case .zikr, .subscribe, .zikrPages, .goToPage, .whatsNew:
            break
        }
        
        switch section {

        case .root:
            let viewModel = MainMenuViewModel(
                databaseService: databaseService,
                router: UnownedRouteTrigger(router: self),
                preferences: preferences,
                player: player
            )
            let view = MainMenuView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            root(viewController)

        case .category(let category):
            let azkar: [ZikrViewModel]

            do {
                azkar = try azkarForCategory(category)
            } catch {
                // TODO: Handle error.
                return
            }

            let viewModel = ZikrPagesViewModel(
                router: UnownedRouteTrigger(router: self),
                category: category,
                title: category.title,
                azkar: azkar,
                preferences: preferences,
                selectedPagePublisher: selectedZikrPageIndex.removeDuplicates().eraseToAnyPublisher(),
                initialPage: selectedZikrPageIndex.value
            )

            if rootViewController.isPadInterface || category == .other {
                let listView = AzkarListView(viewModel: viewModel)
                let listViewController = UIHostingController(rootView: listView)
                listViewController.title = viewModel.title
                if rootViewController.isPadInterface {
                    let viewController = ZikrPagesViewController(viewModel: viewModel)
                    viewController.title = viewModel.title
                    show(listViewController)
                    rootViewController.replaceDetailViewController(with: viewController)
                } else {
                    listViewController.title = category.title
                    listViewController.navigationItem.largeTitleDisplayMode = .never
                    show(listViewController)
                }
            } else {
                let viewController = ZikrPagesViewController(viewModel: viewModel)
                viewController.title = category.title
                viewController.navigationItem.largeTitleDisplayMode = .never
                show(viewController)
            }

        case .zikrPages(let vm):
            let viewController = ZikrPagesViewController(viewModel: vm)
            selectedZikrPageIndex.send(vm.page)
            show(viewController)

        case .zikr(let zikr, let index):
            assert(Thread.isMainThread)
            if let index = index, rootViewController.isPadInterface {
                self.selectedZikrPageIndex.send(index)
                return
            }

            let hadith = try? zikr.hadith.flatMap { id in
                try databaseService.getHadith(id)
            }
            let viewModel = ZikrViewModel(
                zikr: zikr,
                hadith: hadith,
                preferences: preferences,
                player: player
            )
            let view = ZikrView(viewModel: viewModel, incrementAction: Empty().eraseToAnyPublisher())
            let viewController = UIHostingController(rootView: view)

            if rootViewController.isPadInterface {
                rootViewController.replaceDetailViewController(with: viewController)
            } else {
                show(viewController)
            }

        case .goToPage(let page):
            selectedZikrPageIndex.send(page)
            
        case .settings(let initialRoute, let presentModally):
            var navigationController = rootViewController
            if presentModally {
                navigationController = UINavigationController()
                navigationController.navigationBar.prefersLargeTitles = true
            }
            let coordinator = SettingsCoordinator(
                rootViewController: navigationController,
                initialRoute: initialRoute
            )
            startChild(coordinator: coordinator)
            if presentModally {
                navigationController.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    systemItem: .done,
                    primaryAction: UIAction(handler: { _ in
                        self.dismissModal()
                    })
                )
                present(navigationController)
            }

        case .aboutApp:
            let viewModel = AppInfoViewModel(preferences: preferences)
            let view = AppInfoView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.title = L10n.About.title
            show(viewController)
            
        case .subscribe:
            let view = SubscribeView(viewModel: SubscribeViewModel(), closeButtonAction: { [unowned self] in
                self.dismissModal()
            })
            let viewController = UIHostingController(rootView: view)
            if UIDevice.current.isIpadInterface {
                viewController.modalPresentationStyle = .pageSheet
            } else {
                viewController.modalPresentationStyle = .fullScreen
            }
            (rootViewController.presentedViewController ?? rootViewController).present(viewController, animated: true)
            
        case .whatsNew:
            guard let viewController = getWhatsNewViewController() else {
                return
            }
            
            present(viewController)

        }
    }

    private func showDetailViewController(_ viewController: UIViewController, animated: Bool = true) {
        if rootViewController.isPadInterface {
            rootViewController.replaceDetailViewController(with: viewController)
        } else {
            if animated {
                show(viewController)
            } else {
                UIView.performWithoutAnimation {
                    self.show(viewController)
                }
            }
        }
    }

}
