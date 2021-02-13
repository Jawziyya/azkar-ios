//
//  AppInfoViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 02.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit

struct SourceInfo: Identifiable {
    let title: String
    var url: URL?
    var openUrlInApp = true
    var imageName: String?
    var imageType: IconType = .bundled
    var action: (() -> Void)?

    var id: String { title }
}

struct AppInfoViewModel {

    enum Section {
        case versionAndName
        case azkarLegal
        case imagesLegal
        case support
    }

    let appVersion: String

    let iconImageName: String

    let legalInfoHeader = NSLocalizedString("about.credits.sources-header", comment: "Legal information section header.")

    let creditsInfoHeader = NSLocalizedString("about.credits.graphics-header", comment: "Credits section header.")

    let supportHeader = NSLocalizedString("about.support.header", comment: "Support section header.")

    let azkarLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: "azkar.ru", url: URL(string: "https://azkar.ru")!),
    ]

    let imagesLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: NSLocalizedString("about.credits.icon", comment: "App icon credit button."), url: URL(string: "https://flaticon.com/free-icon/moon_414942?term=moon&page=1&position=17")!, imageName: nil),
        SourceInfo(title: NSLocalizedString("about.credits.adobe-arabic-font", comment: "Adobe font credit button."), url: URL(string: "https://fonts.adobe.com/fonts/adobe-arabic")!, imageName: nil),
        SourceInfo(title: NSLocalizedString("about.credits.quran-complex-font", comment: "Quran complex link."), url: URL(string: "https://qurancomplex.gov.sa/en/")!, imageName: nil),
        SourceInfo(title: NSLocalizedString("about.credits.naskh-font", comment: "Google Noto Naskh font."), url: URL(string: "https://www.google.com/get/noto/#naskh-arab")!, imageName: nil),
        SourceInfo(title: NSLocalizedString("about.credits.scheherazade-font", comment: "Scheherazade font credit."), url: URL(string: "https://software.sil.org/scheherazade/")!, imageName: nil),
    ]

    let supportModels: [SourceInfo] = [
        SourceInfo(title: NSLocalizedString("about.support.write-to-email", comment: "Write email button."), url: URL(string: "mailto:azkar.app@pm.me")!, openUrlInApp: false),
        SourceInfo(title: NSLocalizedString("common.share-app", comment: "Share the app button."), openUrlInApp: false, action: {
            let url = URL(string: "https://itunes.apple.com/app/id1511423586")!
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activity, animated: true, completion: nil)
        }),
        SourceInfo(title: NSLocalizedString("about.support.leave-review", comment: "Write review button."), url: URL(string: "https://itunes.apple.com/app/id1511423586?action=write-review&mt=8")!, openUrlInApp: false),
        SourceInfo(title: NSLocalizedString("about.support.telegram-channel", comment: "Telegram channel link."), url: URL(string: "https://telegram.me/jawziyya")!, openUrlInApp: false),
        SourceInfo(title: NSLocalizedString("about.support.jawziyya-apps", comment: "Jawziyya apps button."), url: URL(string: "https://apps.apple.com/ru/developer/al-jawziyya/id1165327318")!, openUrlInApp: false)
    ]

    init(prerences: Preferences) {
        iconImageName = "ic_\(prerences.appIcon.rawValue).png"

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!

        appVersion = "\(NSLocalizedString("common.version", comment: "App version label.")) \(version) (\(build))"
    }

}
