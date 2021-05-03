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

    let currentYear: String

    let dayNightSectionModels: [AzkarMenuItem]
    let otherAzkarModels: [AzkarMenuItem]
    let infoModels: [AzkarMenuOtherItem]

    let fadl = Fadl.all.randomElement()!

    @Published var additionalMenuItems: [AzkarMenuOtherItem] = []

    @Published var selectedNotificationCategory: String?

    @Published var selectedAzkarItem: ZikrCategory?
    @Published var selectedAzkarListItem: ZikrCategory?
    @Published var selectedZikr: Zikr?
    @Published var selectedMenuItem: AzkarMenuOtherItem?

    let player: Player
    let fastingDua: Zikr

    let preferences: Preferences
    let settingsViewModel: SettingsViewModel

    var appIconPackListViewModel: AppIconPackListViewModel {
        .init(preferences: preferences)
    }

    private var cancellabels = Set<AnyCancellable>()

    private lazy var notificationsAccessMenuItem: AzkarMenuOtherItem = {
        let title = NSLocalizedString("alerts.turn-on-notifications-alert", comment: "The alert presented to user before asking for notifications permission.")
        var item = AzkarMenuOtherItem(imageName: "app.badge", title: title, color: Color.blue)
        item.action = {
            NotificationsHandler.shared.requestNotificationsPermission { result in
                switch result {
                case .success:
                    self.hideNotificationsAccessMessage()
                case .failure: break
                }
            }
        }
        return item
    }()

    init(preferences: Preferences, player: Player) {
        self.settingsViewModel = .init(preferences: preferences)
        let azkar = Zikr.data
        let all = azkar.map {
            ZikrViewModel(zikr: $0, preferences: preferences, player: player)
        }
        morningAzkar = all.filter { $0.zikr.category == .morning }
        eveningAzkar = all.filter { $0.zikr.category == .evening }
        afterSalahAzkar = all.filter { $0.zikr.category == .afterSalah }
        otherAzkar = all.filter { $0.zikr.category == .other }
        self.preferences = preferences
        self.player = player

        fastingDua = azkar.first(where: { $0.id == 51 })!

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
            AzkarMenuOtherItem(groupType: .about, imageName: "checkmark.seal.fill", title: NSLocalizedString("root.about", comment: "About app section."), color: Color.green),
            AzkarMenuOtherItem(groupType: .settings, imageName: "gear", title: NSLocalizedString("root.settings", comment: "Settings app section."), color: Color.init(.systemGray)),
        ]

        var year = "\(Date().hijriYear) г.х."
        switch Calendar.current.identifier {
        case .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura:
            break
        default:
            year += " (\(Date().year) г.)"
        }
        currentYear = year

        NotificationsHandler.shared
            .getNotificationsAuthorizationStatus(completion: { [unowned self] status in
                switch status {
                case .notDetermined:
                    self.additionalMenuItems.insert(self.notificationsAccessMenuItem, at: 0)
                default:
                    break
                }
            })
    }

    func azkarForCategory(_ category: ZikrCategory) -> [ZikrViewModel] {
        switch category {
        case .morning: return morningAzkar
        case .evening: return eveningAzkar
        case .afterSalah: return afterSalahAzkar
        case .other: return otherAzkar
        }
    }

    func getZikrViewModel(_ zikr: Zikr) -> ZikrViewModel {
        ZikrViewModel(zikr: zikr, preferences: preferences, player: player)
    }

    func getZikrPagesViewModel(for category: ZikrCategory) -> ZikrPagesViewModel {
        ZikrPagesViewModel(category: category, title: category.title, azkar: azkarForCategory(category), preferences: preferences)
    }

    func hideNotificationsAccessMessage() {
        DispatchQueue.main.async {
            if let index = self.additionalMenuItems.firstIndex(where: { $0 == self.notificationsAccessMenuItem }) {
                self.additionalMenuItems.remove(at: index)
            }
        }
    }

}
