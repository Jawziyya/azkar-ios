//
//  AppDelegate.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import AudioPlayer
import UserNotifications
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    let player = AudioPlayer()
    let notificationsHandler = NotificationsHandler.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        notificationsHandler.removeDeliveredNotifications()

        application.beginReceivingRemoteControlEvents()
        InAppPurchaseService.shared.completeTransactions()
        registerUserDefaults()

        UITableViewCell.appearance().selectionStyle = .none
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UISwitch.appearance().onTintColor = UIColor(named: "accent")

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            return
        }

        switch event.subtype {
        case .remoteControlPlay, .remoteControlStop, .remoteControlPause, .remoteControlTogglePlayPause:
            player.remoteControlReceived(with: event)

        default:
            return
        }
    }

    private func registerUserDefaults() {
        let defaults: [String: Any] = [
            Keys.arabicFont: ArabicFont.noto.fontName,
            Keys.expandTranslation: true,
            Keys.expandTransliteration: true,
            Keys.showTashkeel: true,
            Keys.morningNotificationsTime: defaultMorningNotificationTime,
            Keys.eveningNotificationsTime: defaultEveningNotificationTime,
            Keys.appIcon: AppIcon.gold.rawValue,
            Keys.useSystemFontSize: true,
            Keys.sizeCategory: ContentSizeCategory.medium.floatValue,
        ]

        UserDefaults.standard.register(defaults: defaults)
    }

}

