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

enum RootSection: Equatable {
    case root
    case category(ZikrCategory)
    case zikr(_ zikr: Zikr, index: Int? = nil)
    case zikrPages(_ vm: ZikrPagesViewModel, page: Int?)
    case goToPage(Int)
    case modalSettings(SettingsViewModel.SettingsMode)
    case settings(SettingsSection)
    case aboutApp
    case subscribe
    case dismissModal
    case notificationsList
}

protocol RootRouter: AnyObject {
    func trigger(_ route: RootSection)
}

final class RootCoordinator: NavigationCoordinator, RootRouter {

    let preferences: Preferences
    let deeplinker: Deeplinker
    let player: Player

    let morningAzkar: [ZikrViewModel]
    let eveningAzkar: [ZikrViewModel]
    let afterSalahAzkar: [ZikrViewModel]
    let otherAzkar: [ZikrViewModel]

    private let selectedZikrPageIndex = CurrentValueSubject<Int, Never>(0)

    private var cancellables = Set<AnyCancellable>()

    init(preferences: Preferences, deeplinker: Deeplinker, player: Player) {
        self.preferences = preferences
        self.deeplinker = deeplinker
        self.player = player

        let azkar = Zikr.data
        let all = azkar
            .sorted(by: { $0.rowInCategory < $1.rowInCategory })
            .map {
                ZikrViewModel(zikr: $0, preferences: preferences, player: player)
            }
        morningAzkar = all.filter { $0.zikr.category == .morning }
        eveningAzkar = all.filter { $0.zikr.category == .evening }
        afterSalahAzkar = all.filter { $0.zikr.category == .afterSalah }
        otherAzkar = all.filter { $0.zikr.category == .other }

        let navigationController = UINavigationController()
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.navigationBar.prefersLargeTitles = true

        super.init(rootViewController: navigationController)
        
        preferences.$colorTheme
            .receive(on: RunLoop.main)
            .prepend(preferences.colorTheme)
            .sink(receiveValue: { theme in
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

    func azkarForCategory(_ category: ZikrCategory) -> [ZikrViewModel] {
        switch category {
        case .morning: return morningAzkar
        case .evening: return eveningAzkar
        case .afterSalah: return afterSalahAzkar
        case .other: return otherAzkar
        }
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
        section = .settings(.root)
    }

}

private extension RootCoordinator {

    func handleSelection(_ section: RootSection) {
        switch section {
        case .aboutApp, .category, .root, .settings:
            selectedZikrPageIndex.send(0)
        case .zikr, .subscribe, .dismissModal, .modalSettings, .notificationsList, .zikrPages, .goToPage:
            break
        }
        
        switch section {

        case .root:
            let viewModel = MainMenuViewModel(
                router: self,
                preferences: preferences,
                player: player
            )
            let view = MainMenuView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            root(viewController)

        case .category(let category):
            let viewModel = ZikrPagesViewModel(
                router: self,
                category: category,
                title: category.title,
                azkar: azkarForCategory(category),
                preferences: preferences,
                selectedPagePublisher: selectedZikrPageIndex.eraseToAnyPublisher()
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

        case .zikrPages(let vm, let page):
            let viewController = ZikrPagesViewController(viewModel: vm)
            selectedZikrPageIndex.send(page ?? 0)
            show(viewController)

        case .zikr(let zikr, let index):
            assert(Thread.isMainThread)
            if let index = index, rootViewController.isPadInterface {
                self.selectedZikrPageIndex.send(index)
                return
            }

            let viewModel = ZikrViewModel(zikr: zikr, preferences: preferences, player: player)
            let view = ZikrView(viewModel: viewModel, incrementAction: Empty().eraseToAnyPublisher())
            let viewController = UIHostingController(rootView: view)

            if rootViewController.isPadInterface {
                rootViewController.replaceDetailViewController(with: viewController)
            } else {
                show(viewController)
            }

        case .goToPage(let page):
            selectedZikrPageIndex.send(page)

        case .settings(let section):
            let viewModel = SettingsViewModel(preferences: preferences, notificationsHandler: NotificationsHandler.shared, router: self)
            let view = SettingsView(viewModel: viewModel)

            switch section {

            case .root:
                let viewController = view.wrapped
                viewController.title = L10n.Settings.title
                viewController.navigationItem.largeTitleDisplayMode = .always
                showDetailViewController(viewController)

            case .icons:
                let viewController = view.iconPicker.wrapped
                viewController.title = L10n.Settings.Icon.title
                showDetailViewController(viewController)

            case .themes:
                let viewController = view.themePicker.wrapped
                viewController.title = L10n.Settings.Theme.title
                showDetailViewController(viewController)

            case .arabicFonts:
                let viewController = view.textSettingsSection.wrapped
                showDetailViewController(viewController)
                
            case .fonts:
                break

            }
            
        case .modalSettings(let mode):
            let viewModel = SettingsViewModel(mode: mode, preferences: preferences, notificationsHandler: NotificationsHandler.shared, router: self)
            let view = SettingsView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.title = L10n.Settings.title
            let navigationController = UINavigationController(rootViewController: viewController)
            if UIDevice.current.isIpadInterface {
                navigationController.modalPresentationStyle = .formSheet
            } else {
                navigationController.modalPresentationStyle = .popover
            }
            present(navigationController)

        case .aboutApp:
            let viewModel = AppInfoViewModel(preferences: preferences)
            let view = AppInfoView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.title = L10n.About.title
            show(viewController)
            
        case .subscribe:
            let view = SubscribeView(viewModel: SubscribeViewModel(), closeButtonAction: { [unowned self] in
                self.trigger(.dismissModal)
            })
            let viewController = UIHostingController(rootView: view)
            if UIDevice.current.isIpadInterface {
                viewController.modalPresentationStyle = .pageSheet
            } else {
                viewController.modalPresentationStyle = .fullScreen
            }
            (rootViewController.presentedViewController ?? rootViewController).present(viewController, animated: true)

        case .notificationsList:
            let viewModel = NotificationsListViewModel(notifications: UNUserNotificationCenter.current().pendingNotificationRequests)
            let view = NotificationsListView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            show(viewController)
            
        case .dismissModal:
            (rootViewController.presentedViewController ?? rootViewController).dismiss(animated: true)

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
