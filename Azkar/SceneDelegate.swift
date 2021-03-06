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
    let deeplinker = Deeplinker()

    private var cancellabels = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let audioPlayer = AppDelegate.shared.player
        let notificationsHandler = AppDelegate.shared.notificationsHandler

        let preferences = Preferences()

        let mainViewModel = MainMenuViewModel(preferences: preferences, player: Player(player: audioPlayer))

        let zikrCategory = notificationsHandler
            .selectedNotificationCategory
            .map { id -> ZikrCategory? in
                guard let category = ZikrCategory(rawValue: id) else {
                    return nil
                }
                return category
            }

        zikrCategory
            .map { category -> Deeplinker.Route? in
                guard let category = category else {
                    return nil
                }
                return Deeplinker.Route.azkar(category)
            }
            .delay(for: .seconds(0.3), scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: \.route, on: deeplinker)
            .store(in: &cancellabels)

        let mainView = MainMenuView(viewModel: mainViewModel)
            .environmentObject(deeplinker)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = OrientationLockedController(rootView: mainView)
            self.window = window
            window.makeKeyAndVisible()

            preferences.$theme
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { theme in
                    window.overrideUserInterfaceStyle = theme.userInterfaceStyle
                }
                .store(in: &cancellabels)
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
