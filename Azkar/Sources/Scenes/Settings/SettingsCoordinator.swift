// Copyright © 2023 Azkar
// All Rights Reserved.

import UIKit
import SwiftUI
import Stinsen
import AboutApp

enum SettingsRoute: Hashable, RouteKind {
    case subscribe, notificationsList
    case appearance, text, counter
    case reminders, adhkarReminders, jumuaReminders, soundPicker(ReminderSound)
    case aboutApp
}

final class SettingsCoordinator: RouteTrigger, Identifiable, NavigationCoordinatable {
    var stack = Stinsen.NavigationStack<SettingsCoordinator>(initial: \.root)
    
    @Root var root = makeRootView
    @Route(.push) var appearance = makeAppearanceView
    @Route(.push) var notificationsList = makeNotificationsListView
    @Route(.push) var text = makeTextView
    @Route(.push) var counter = makeCounterView
    @Route(.push) var reminders = makeRemindersView
    @Route(.push) var adhkarReminders = makeAdhkarRemindersView
    @Route(.push) var jumuaReminders = makeJumuaRemindersView
    @Route(.push) var soundPicker = makeSoundPickerView
    @Route(.modal) var subscribe = makeSubscribeView
    @Route(.push) var aboutApp = makeAboutAppView
        
    private let databaseService: AzkarDatabase
    private let preferences: Preferences
    private let subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create()
    
    init(
        databaseService: AzkarDatabase,
        preferences: Preferences = Preferences.shared,
        initialRoute: SettingsRoute?
    ) {
        self.databaseService = databaseService
        self.preferences = preferences
        if let initialRoute {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.trigger(initialRoute)
            }
        }
    }
    
    private func createRouter() -> UnownedRouteTrigger<SettingsRoute> {
        UnownedRouteTrigger(router: self)
    }
    
    func trigger(_ route: SettingsRoute) {
        switch route {
            
        case .notificationsList:
            self.route(to: \.notificationsList)
            
        case .subscribe:
            self.route(to: \.subscribe)
            
        case .appearance:
            self.route(to: \.appearance)
            
        case .text:
            self.route(to: \.text)
            
        case .counter:
            self.route(to: \.counter)

        case .reminders:
            self.route(to: \.reminders)
            
        case .adhkarReminders:
            self.route(to: \.adhkarReminders)
            
        case .jumuaReminders:
            self.route(to: \.jumuaReminders)
            
        case .soundPicker(let currentSound):
            self.route(to: \.soundPicker, currentSound)
            
        case .aboutApp:
            self.route(to: \.aboutApp)

        }
    }
    
}

extension SettingsCoordinator {
    
    func makeRootView() -> some View {
        let viewModel = SettingsViewModel(
            databaseService: databaseService,
            preferences: preferences,
            router: createRouter()
        )
        return SettingsView(viewModel: viewModel)
    }
    
    func makeAppearanceView() -> some View {
        AppearanceScreen(viewModel: AppearanceViewModel(
            router: createRouter()
        ))
    }
    
    func makeNotificationsListView() -> some View {
        let viewModel = NotificationsListViewModel(notifications: UNUserNotificationCenter.current().pendingNotificationRequests)
        return NotificationsListView(viewModel: viewModel)
    }
    
    func makeTextView() -> some View {
        let viewModel = TextSettingsViewModel(router: createRouter())
        return TextSettingsScreen(viewModel: viewModel)
    }
    
    func makeCounterView() -> some View {
        let viewModel = CounterViewModel(router: createRouter())
        return CounterView(viewModel: viewModel)
    }
    
    func makeRemindersView() -> some View {
        RemindersScreen(viewModel: RemindersViewModel(router: createRouter()))
    }
    
    func makeAdhkarRemindersView() -> some View {
        AdhkarRemindersView(viewModel: AdhkarRemindersViewModel(
            router: self.createRouter()
        ))
    }
    
    func makeJumuaRemindersView() -> some View {
        JumuaRemindersView(viewModel: JumuaRemindersViewModel(
            router: self.createRouter()
        ))
    }
    
    func makeSoundPickerView(_ sound: ReminderSound) -> some View {
        ReminderSoundPickerView(viewModel: ReminderSoundPickerViewModel(
            preferredSound: sound,
            subscribeScreenTrigger: {
                self.route(to: \.subscribe)
            }
        ))
    }

    func makeSubscribeView() -> some View {
        SubscribeView(viewModel: SubscribeViewModel())
    }
    
    func makeAboutAppView() -> some View {
        AppInfoView(viewModel: AppInfoViewModel(
            appVersion: {
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
                let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!
                return "\(L10n.Common.version) \(version) (\(build))"
            }(),
            isProUser: subscriptionManager.isProUser()
        ))
    }
    
}
