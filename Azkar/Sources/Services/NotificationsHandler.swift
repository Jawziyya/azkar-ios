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
    
    enum NotificationsPermissionState: Equatable {
        /// Azkar did not ask for permissions.
        case notDetermined
        
        /// Azkar asked permission but user denied.
        case denied
        
        /// Azkar has access to send notifications withoud sound.
        case noSound
        
        /// Azkar has access to send notifications.
        case granted
        
        var hasAccess: Bool {
            switch self {
            case .noSound, .granted:
                return true
            case .denied, .notDetermined:
                return false
            }
        }
        
        var isDenied: Bool {
            switch self {
            case .denied:
                return true
            default:
                return false
            }
        }
    }

    static let shared = NotificationsHandler()

    let selectedNotificationCategory = PassthroughSubject<String, Never>()
    
    var notificationsPermissionStatePublisher: AnyPublisher<NotificationsPermissionState, Never> {
        Publishers
            .Merge(
                NotificationCenter.default
                    .publisher(for: UIApplication.didBecomeActiveNotification, object: nil)
                    .eraseToAnyPublisher()
                    .toVoid()
                    .prepend(())
                    .flatMap { [unowned self] in self.readNotificationSettings() },
                readNotificationSettings()
            )
            .map { settings -> NotificationsPermissionState in
                switch settings.authorizationStatus {
                case .notDetermined:
                    return .notDetermined
                case .denied:
                    return .denied
                case .authorized, .ephemeral, .provisional:
                    let soundAccessDisabled = settings.soundSetting == .disabled
                    if soundAccessDisabled {
                        return .noSound
                    } else {
                        return .granted
                    }
                default:
                    return .notDetermined
                }
            }
            .eraseToAnyPublisher()
    }

    private let notificationCenter = UNUserNotificationCenter.current()
    private var cancellables = Set<AnyCancellable>()

    private override init() {
        super.init()
        notificationCenter.delegate = self

        // Clean up the notifications list.
        notificationCenter.removeAllDeliveredNotifications()
    }
    
    private func readNotificationSettings() -> AnyPublisher<UNNotificationSettings, Never> {
        Future { observer in
            UNUserNotificationCenter.current()
                .getNotificationSettings { settings in
                    observer(.success(settings))
                }
        }
        .eraseToAnyPublisher()
    }

    func removeDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
    }

    func removeScheduledNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }

    func scheduleNotification(id: String, date: Date, titleKey: String, categoryId: String, sound: ReminderSound) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: titleKey, arguments: nil)
        content.sound = sound.notificationSound
        content.categoryIdentifier = categoryId
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: date), repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request)
    }
    
    func scheduleNotification(id: String, titleKey: String, dateComponents: DateComponents, categoryId: String, sound: ReminderSound) {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: titleKey, arguments: nil)
        content.sound = sound.notificationSound
        content.categoryIdentifier = categoryId
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
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
