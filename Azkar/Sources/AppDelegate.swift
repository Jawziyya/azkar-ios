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
import RevenueCat
import Entities
import Library
import FirebaseCore
import FirebaseMessaging

@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {

    let player = AudioPlayer()
    let notificationsHandler = NotificationsHandler.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        application.beginReceivingRemoteControlEvents()
        application.registerForRemoteNotifications()
        initialize()
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        notificationsHandler.handlePushNotificationToken(deviceToken)
    }

    private func initialize() {
        FontsHelper.registerFonts()

        notificationsHandler.removeDeliveredNotifications()

        notificationsHandler
            .getNotificationsAuthorizationStatus(completion: { status in
                switch status {
                case .notDetermined:
                    NotificationsHandler.shared.requestNotificationsPermission { _ in }
                default:
                    break
                }
            })

        InAppPurchaseService.shared.completeTransactions()
        registerUserDefaults()
        setupRevenueCat()
        setupFirebase()
    }
        
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event else {
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
            Keys.expandTranslation: true,
            Keys.expandTransliteration: false,
            Keys.showTashkeel: true,
            
            Keys.enableGoToNextZikrOnCounterFinished: true,
            Keys.alignCounterByLeadingSide: true,
            
            Keys.enableReminders: true,
            Keys.morningNotificationsTime: defaultMorningNotificationTime,
            Keys.eveningNotificationsTime: defaultEveningNotificationTime,
            
            Keys.appIcon: AppIcon.gold.rawValue,
            
            Keys.useSystemFontSize: true,
            Keys.sizeCategory: ContentSizeCategory.medium.floatValue,
            Keys.lineSpacing: LineSpacing.s.rawValue,
            Keys.translationLineSpacing: LineSpacing.s.rawValue,
            
            Keys.zikrReadingMode: ZikrReadingMode.normal.rawValue,
            Keys.zikrCollectionSource: ZikrCollectionSource.hisnulMuslim.rawValue,
        ]

        UserDefaults.standard.register(defaults: defaults)
    }
    
    private func setupRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: Bundle.main.object(forInfoDictionaryKey: "REVENUCE_CAT_API_KEY") as! String)
        SubscriptionManager.shared.loadProducts()
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = notificationsHandler
        AnalyticsReporter.addTarget(FirebaseAnalyticsTarget.shared)
    }
    
}
