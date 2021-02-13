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

    let morningAzkar: [ZikrViewModel]
    let eveningAzkar: [ZikrViewModel]
    let afterSalahAzkar: [ZikrViewModel]
    let otherAzkar: [ZikrViewModel]

    let dayNightSectionModels: [AzkarMenuItem]
    let otherAzkarModels: [AzkarMenuItem]
    let infoModels: [AzkarMenuOtherItem]

    @Published var notificationAccessModel: AzkarMenuOtherItem?

    @Published var selectedNotificationCategory: String?
    @Published var selectedMenuItem: AzkarMenuItem?

    let player: Player

    let preferences: Preferences
    let settingsViewModel: SettingsViewModel

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences, player: Player) {
        self.settingsViewModel = .init(preferences: preferences)
        let all = Zikr.data.map {
            ZikrViewModel(zikr: $0, preferences: preferences, player: player)
        }
        morningAzkar = all.filter { $0.zikr.category == .morning }
        eveningAzkar = all.filter { $0.zikr.category == .evening }
        afterSalahAzkar = all.filter { $0.zikr.category == .afterSalah }
        otherAzkar = all.filter { $0.zikr.category == .other }
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
            AzkarMenuOtherItem(groupType: .legal, icon: "checkmark.seal.fill", title: NSLocalizedString("root.about", comment: "About app section."), color: Color.green),
            AzkarMenuOtherItem(groupType: .settings, icon: "gear", title: NSLocalizedString("root.settings", comment: "Settings app section."), color: Color.init(.systemGray)),
        ]

        UNUserNotificationCenter.current().getNotificationSettings { settings
            in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    let title = NSLocalizedString("alerts.turn-on-notifications-alert", comment: "The alert presented to user before asking for notifications permission.")
                    self.notificationAccessModel = .init(groupType: .notificationsAccess, icon: nil, title: title, color: Color.init(.link))
                default:
                    break
                }
            }
        }

        $selectedNotificationCategory
            .map { [unowned self] category in
                let sectionModels = self.dayNightSectionModels + self.otherAzkarModels
                let targetModel = sectionModels.first(where: { $0.category.rawValue == category })
                return targetModel
            }
            .assign(to: \.selectedMenuItem, on: self)
            .store(in: &cancellabels)
    }

    func azkarForCategory(_ category: ZikrCategory) -> [ZikrViewModel] {
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
