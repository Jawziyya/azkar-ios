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

    @Published var title = ""

    unowned let router: RootRouter

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

    func getDayNightSectionModels(isDarkModeEnabled: Bool) -> [MainMenuLargeGroupViewModel] {
        [
            MainMenuLargeGroupViewModel(category: .morning, title: MainMenuItem.morning.localizedTitle, animationName: "sun", animationSpeed: 0.3),
            MainMenuLargeGroupViewModel(category: .evening, title: MainMenuItem.evening.localizedTitle, animationName: isDarkModeEnabled ? "moon" : "moon2", animationSpeed: 0.2),
        ]
    }

    let otherAzkarModels: [AzkarMenuItem]
    let infoModels: [AzkarMenuOtherItem]
    
    let fadlText: String
    let fadlSource: String

    @Published var additionalMenuItems: [AzkarMenuOtherItem] = []
    @Published var enableEidBackground = false

    @Preference("kDidDisplayIconPacksMessage", defaultValue: false)
    var kDidDisplayIconPacksMessage

    let player: Player
    let fastingDua: Zikr

    let preferences: Preferences

    private var cancellabels = Set<AnyCancellable>()

    private var isIpad: Bool {
        UIDevice.current.isIpad
    }

    private func getRandomEmoji() -> String {
        ["🌙", "🌸", "☘️", "🌳", "🌴", "🌱", "🌼", "💫", "🌎", "🌍", "🌏", "🪐", "✨", "❄️"].randomElement()!
    }

    private lazy var notificationsAccessMenuItem: AzkarMenuOtherItem = {
        let title = L10n.Alerts.turnOnNotificationsAlert
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

    private lazy var iconsPackMessage: AzkarMenuOtherItem = {
        let title = L10n.Alerts.checkoutIconPacks
        var item = AzkarMenuOtherItem(imageName: AppIconPack.maccinz.icons.randomElement()!.imageName, title: title, color: Color.red, iconType: .bundled, imageCornerRadius: 4)
        item.action = { [unowned self] in
            self.kDidDisplayIconPacksMessage = true
            self.hideIconPacksMessage()
            self.navigateToIconPacksList()
        }
        return item
    }()

    init(router: RootRouter, preferences: Preferences, player: Player) {
        self.router = router
        let azkar = Zikr.data
        let all = azkar
            .sorted(by: { $0.rowInCategory < $1.rowInCategory })
            .map {
                ZikrViewModel(zikr: $0, preferences: preferences, player: player)
            }
        morningAzkar = all.filter { $0.zikr.category == .morning }
        eveningAzkar = all.filter { $0.zikr.category == .evening }
        afterSalahAzkar = all.filter { $0.zikr.category == .afterSalah }
        otherAzkar = all.filter { $0.zikr.category == .other }
        self.preferences = preferences
        self.player = player

        fastingDua = azkar.first(where: { $0.id == 51 })!

        otherAzkarModels = [
            AzkarMenuItem(category: .afterSalah, imageName: "mosque", title: L10n.Category.afterSalah, color: Color.init(.systemBlue), count: afterSalahAzkar.count, iconType: .bundled),
            AzkarMenuItem(category: .other, imageName: "square.stack.3d.down.right.fill", title: L10n.Category.other, color: Color.init(.systemTeal), count: otherAzkar.count),
        ]

        infoModels = [
            AzkarMenuOtherItem(groupType: .about, imageName: "info.circle", title: L10n.Root.about, color: Color.init(.systemGray)),
            AzkarMenuOtherItem(groupType: .settings, imageName: "gear", title: L10n.Root.settings, color: Color.init(.systemGray)),
        ]
        
        let fadl = Fadl.all.randomElement()!
        fadlText = fadl.text
        fadlSource = fadl.source

        var year = "\(Date().hijriYear) г.х."
        switch Calendar.current.identifier {
        case .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura:
            break
        default:
            year += " (\(Date().year) г.)"
        }
        currentYear = year

        if !kDidDisplayIconPacksMessage {
            additionalMenuItems.append(iconsPackMessage)
        }

        NotificationsHandler.shared
            .getNotificationsAuthorizationStatus(completion: { [unowned self] status in
                switch status {
                case .notDetermined:
                    self.additionalMenuItems.insert(self.notificationsAccessMenuItem, at: 0)
                default:
                    break
                }
            })

        let appName = L10n.appName
        let title = "\(appName)"
        preferences.$enableFunFeatures
            .map { [unowned self] flag in
                if flag {
                    return title + " \(self.getRandomEmoji())"
                } else {
                    return title
                }
            }
            .assign(to: \.title, on: self)
            .store(in: &cancellabels)

        preferences.$enableFunFeatures
            .map { flag in flag && Date().isRamadanEidDays }
            .assign(to: \.enableEidBackground, on: self)
            .store(in: &cancellabels)
        
        preferences.$colorTheme
            .sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
            })
            .store(in: &cancellabels)
    }

    private func hideNotificationsAccessMessage() {
        DispatchQueue.main.async {
            if let index = self.additionalMenuItems.firstIndex(where: { $0 == self.notificationsAccessMenuItem }) {
                self.additionalMenuItems.remove(at: index)
            }
        }
    }

    private func hideIconPacksMessage() {
        DispatchQueue.main.async {
            if let index = self.additionalMenuItems.firstIndex(where: { $0 == self.iconsPackMessage }) {
                self.additionalMenuItems.remove(at: index)
            }
        }
    }

    func navigateToZikr(_ zikr: Zikr) {
        router.trigger(.zikr(zikr))
    }

    func navigateToCategory(_ category: ZikrCategory) {
        router.trigger(.category(category))
    }

    func navigateToAboutScreen() {
        router.trigger(.aboutApp)
    }

    func navigateToSettings() {
        router.trigger(.settings(.root))
    }

    func navigateToIconPacksList() {
        router.trigger(.settings(.icons))
    }

    func navigateToMenuItem(_ item: AzkarMenuOtherItem) {
        switch item.groupType {
        case .about:
            navigateToAboutScreen()
        case .settings:
            navigateToSettings()
        default:
            break
        }
    }

}
