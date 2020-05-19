//
//  NotificationsHandler.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class NotificationsHandler: NSObject {

    let selectedNotificationId = PassthroughSubject<String?, Never>()

    private let notificationCenter = UNUserNotificationCenter.current()

    override init() {
        super.init()
        notificationCenter.delegate = self

        // Clean up the notifications list.
        notificationCenter.removeAllDeliveredNotifications()
    }

}

extension NotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Just present the notification as it comes.
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(request: response.notification.request, completionHandler: completionHandler)
    }

    private func handleNotification(request: UNNotificationRequest, completionHandler: @escaping () -> Void) {
        let category = request.content.userInfo["category"] as? String
        selectedNotificationId.send(category)
        completionHandler()
    }

}
