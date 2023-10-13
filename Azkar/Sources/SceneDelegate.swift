//
//  SceneDelegate.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let deeplinker = Deeplinker()
    private let preferences = Preferences.shared

    private var cancellables = Set<AnyCancellable>()
    private var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let notificationsHandler = AppDelegate.shared.notificationsHandler

        notificationsHandler
            .selectedNotificationCategory
            .map { id -> ZikrCategory? in
                guard let category = ZikrCategory(rawValue: id) else {
                    return nil
                }
                return category
            }
            .map { category -> Deeplinker.Route? in
                guard let category = category else {
                    return nil
                }
                return Deeplinker.Route.azkar(category)
            }
            .assign(to: \.route, on: deeplinker)
            .store(in: &cancellables)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window: UIWindow
            if CommandLine.arguments.contains("DEMO_MODE") {
                window = GSTouchesShowingWindow(windowScene: windowScene)
            } else {
                window = UIWindow(windowScene: windowScene)
                window.backgroundColor = UIColor.systemBackground
            }

            let rootCoordinator = RootCoordinator(
                preferences: preferences,
                deeplinker: deeplinker,
                player: Player(player: AppDelegate.shared.player)
            )

            let rootViewController: UIViewController
            if UIDevice.current.isIpadInterface {
                let splitViewController = UISplitViewController(style: .doubleColumn)
                let detailViewController = UIHostingController(rootView: ipadDetailView)
                splitViewController.viewControllers = [rootCoordinator.rootViewController, detailViewController]
                rootViewController = splitViewController
            } else {
                rootViewController = rootCoordinator.rootViewController
            }

            window.rootViewController = rootViewController
            self.rootCoordinator = rootCoordinator
            window.makeKeyAndVisible()
            rootCoordinator.start { }

            preferences.$theme
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { theme in
                    window.overrideUserInterfaceStyle = theme.userInterfaceStyle
                }
                .store(in: &cancellables)
        }

    }

    private var ipadDetailView: some View {
        Color.background
        .overlay(
            Text("←  ").font(Font.system(.body, design: .rounded).weight(.light).smallCaps()) + Text("root.pick-section", comment: "Pick section label.")
            ,
            alignment: .center
        )
        .font(Font.system(.title2, design: .rounded).smallCaps())
        .foregroundColor(Color.secondary)
        .edgesIgnoringSafeArea(.all)
    }

}
