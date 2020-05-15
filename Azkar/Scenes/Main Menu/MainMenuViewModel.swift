//
//  MainMenuViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 01.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import AudioPlayer
import Combine

final class MainMenuViewModel: ObservableObject {

    enum Section: CaseIterable {
        case dayNight
        case afterSalah
        case info
        case notificationsAccess
    }

    let morningAzkar: [Zikr]
    let eveningAzkar: [Zikr]
    let afterSalahAzkar: [Zikr]
    let otherAzkar: [Zikr]

    let dayNightSectionModels: [AzkarMenuItem]
    let otherAzkarModels: [AzkarMenuItem]
    let infoModels: [AzkarMenuOtherItem]
    @Published var notificationAccessModel: AzkarMenuOtherItem?

    let player: Player

    let preferences: Preferences
    let settingsViewModel: SettingsViewModel

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences, player: Player) {
        self.settingsViewModel = .init(preferences: preferences)
        let all = Zikr.data
        morningAzkar = all.filter { $0.category == .morning }
        eveningAzkar = all.filter { $0.category == .evening }
        afterSalahAzkar = all.filter { $0.category == .afterSalah }
        otherAzkar = all.filter { $0.category == .other }
        self.preferences = preferences
        self.player = player

        let morning = MainMenuItem.morning
        let evening = MainMenuItem.evening

        dayNightSectionModels = [
            AzkarMenuItem(category: .morning, imageName: morning.imageName, title: morning.localizedTitle, color: Color(.systemBlue), count: morningAzkar.count),
            AzkarMenuItem(category: .evening, imageName: evening.imageName, title: evening.localizedTitle, color: Color(.systemIndigo), count: eveningAzkar.count)
        ]

        otherAzkarModels = [
            AzkarMenuItem(category: .afterSalah, imageName: "mosque", title: "Азкары после молитвы", color: Color.init(.systemBlue), count: afterSalahAzkar.count, iconType: .bundled),
            AzkarMenuItem(category: .other, imageName: "square.stack.3d.down.right.fill", title: "Важные азкары", color: Color.init(.systemTeal), count: otherAzkar.count),
        ]

        infoModels = [
//            AzkarMenuOtherItem(groupType: .fadail, icon: "info.circle.fill", title: "Достоинства поминания Аллаха", color: Color(.systemGreen)),
            AzkarMenuOtherItem(groupType: .legal, icon: "checkmark.seal.fill", title: "О приложении", color: Color.accent),
            AzkarMenuOtherItem(groupType: .settings, icon: "gear", title: "Настройки", color: Color.init(.systemGray)),
        ]

        UNUserNotificationCenter.current().getNotificationSettings { settings
            in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self.notificationAccessModel = .init(groupType: .notificationsAccess, icon: nil, title: "Включите уведомления, чтобы приложение напоминало о времени утренних и вечерних азкаров", color: Color.init(.link))
                default:
                    break
                }
            }
        }
    }

    func azkarForCategory(_ category: ZikrCategory) -> [Zikr] {
        switch category {
        case .morning: return morningAzkar
        case .evening: return eveningAzkar
        case .afterSalah: return afterSalahAzkar
        case .other: return otherAzkar
        }
    }

    func hideNotificationsAccessMessage() {
        DispatchQueue.main.async {
            self.notificationAccessModel = nil
        }
    }

}
