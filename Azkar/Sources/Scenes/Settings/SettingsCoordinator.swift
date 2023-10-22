// Copyright © 2023 Azkar
// All Rights Reserved.

import UIKit
import SwiftUI
import Coordinator

enum SettingsRoute: Equatable, Route {
    case root, subscribe, notificationsList
    case appearance, text, counter, reminders
}

final class SettingsCoordinator: NavigationCoordinator, RouteTrigger {
    
    private let initialRoute: SettingsRoute?
    
    init(rootViewController: UINavigationController?, initialRoute: SettingsRoute?) {
        self.initialRoute = initialRoute
        super.init(rootViewController: rootViewController)
    }
    
    override func start(with completion: @escaping () -> Void) {
        super.start(with: completion)
        if let initialRoute {
            trigger(initialRoute)
        } else {
            trigger(.root)
        }
    }
    
    func trigger(_ route: SettingsRoute) {
        switch route {

        case .root:
            let viewModel = SettingsViewModel(
                databaseService: DatabaseService.init(language: .getSystemLanguage()),
                preferences: Preferences.shared,
                router: UnownedRouteTrigger(router: self)
            )
            let view = SettingsView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            viewController.title = L10n.Settings.title
            show(viewController)
            
        case .notificationsList:
            let viewModel = NotificationsListViewModel(notifications: UNUserNotificationCenter.current().pendingNotificationRequests)
            let view = NotificationsListView(viewModel: viewModel)
            let viewController = UIHostingController(rootView: view)
            show(viewController)
            
        case .subscribe:
            let viewController = createSubscribeViewController { [unowned self] in
                self.dismissModal()
            }
            (rootViewController.presentedViewController ?? rootViewController).present(viewController, animated: true)
            
        case .appearance:
            let viewModel = AppearanceViewModel(router: UnownedRouteTrigger(router: self))
            let view = AppearanceScreen(viewModel: viewModel)
            showView(view, title: L10n.Settings.Theme.title)
            
        case .text:
            let viewModel = TextSettingsViewModel(router: UnownedRouteTrigger(router: self))
            let view = TextSettingsScreen(viewModel: viewModel)
            showView(view, title: L10n.Settings.Text.title)
            
        case .counter:
            let viewModel = CounterViewModel(router: UnownedRouteTrigger(router: self))
            let view = CounterView(viewModel: viewModel)
            showView(view, title: L10n.Settings.Counter.title)

        case .reminders:
            let viewModel = RemindersViewModel(router: UnownedRouteTrigger(router: self))
            let view = RemindersScreen(viewModel: viewModel)
            showView(view, title: L10n.Settings.Reminders.title)

        }
    }
    
    private func showView(_ view: some View, title: String) {
        let viewController = UIHostingController(
            rootView: view.tint(Color.accent)
        )
        viewController.title = title
        show(viewController)
    }
    
}
