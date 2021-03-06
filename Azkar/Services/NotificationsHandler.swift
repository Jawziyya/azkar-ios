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

    static let shared = NotificationsHandler()

    let selectedNotificationCategory = PassthroughSubject<String, Never>()

    private let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        notificationCenter.delegate = self

        // Clean up the notifications list.
        notificationCenter.removeAllDeliveredNotifications()
    }

    func removeDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }

    func removeScheduledNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func scheduleNotification(id: String, date: Date, title: String, categoryId: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = categoryId
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request)
    }

    func getNotificationsAuthorizationStatus(completion: @escaping ((UNAuthorizationStatus) -> Void)) {
        UNUserNotificationCenter.current().getNotificationSettings { settings
            in
            completion(settings.authorizationStatus)
        }
    }

    func requestNotificationsPermission(completion: @escaping ((Result<Bool, Error>) -> Void)) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, ]) { (granted, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(granted))
                }
            }
    }

}

extension NotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Just present the notification as it comes.
        completionHandler([.list, .sound, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(request: response.notification.request, completionHandler: completionHandler)
    }

    private func handleNotification(request: UNNotificationRequest, completionHandler: @escaping () -> Void) {
        let category = request.content.categoryIdentifier
        selectedNotificationCategory.send(category)
        completionHandler()
    }

}
