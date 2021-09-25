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

    var sections: [Section] = []

    struct Section: Identifiable {
        let id = UUID().uuidString
        var header: String?
        var footer: String?
        let items: [SourceInfo]
    }

    let appVersion: String

    let iconImageName: String

    private let materialsCredits: [SourceInfo] = [
        SourceInfo(title: L10n.About.azkarRU, url: URL(string: "https://azkar.ru")!),
        SourceInfo(title: L10n.About.sourceCode, url: URL(string: "https://github.com/Jawziyya/azkar-ios")!),
    ]

    private let graphicMaterialsCredits: [SourceInfo] = [
        SourceInfo(title: L10n.About.Credits.image("Moon"), url: URL(string: "https://flaticon.com/free-icon/moon_414942?term=moon&page=1&position=17")!, imageName: nil),
        SourceInfo(title: L10n.About.Credits.font("Abode Arabic"), url: URL(string: "https://fonts.adobe.com/fonts/adobe-arabic")!),
        SourceInfo(title: L10n.About.Credits.quranComplexFont, url: URL(string: "https://qurancomplex.gov.sa/en/")!),
        SourceInfo(title: L10n.About.Credits.font("Google Noto Naskh"), url: URL(string: "https://www.google.com/get/noto/#naskh-arab")!),
        SourceInfo(title: L10n.About.Credits.font("Scheherazade"), url: URL(string: "https://software.sil.org/scheherazade/")!),
        SourceInfo(title: L10n.About.Credits.animation("Sunny"), url: URL(string: "https://lottiefiles.com/50649-sunny")!),
        SourceInfo(title: L10n.About.Credits.animation("Moon & Stars"), url: URL(string: "https://lottiefiles.com/12572-moon-stars")!),
        SourceInfo(title: L10n.About.Credits.animation("Weather Night"), url: URL(string: "https://lottiefiles.com/4799-weather-night")!),
    ]

    private let openSourceLibraries: [SourceInfo] = [
        SourceInfo(title: "Lottie", url: URL(string: "https://github.com/airbnb/lottie-ios")!),
        SourceInfo(title: "Coordinator", url: URL(string: "https://github.com/radianttap/Coordinator")),
        SourceInfo(title: "SwiftGen", url: URL(string: "https://github.com/SwiftGen/SwiftGen")),
        SourceInfo(title: "SwiftRichString", url: URL(string: "https://github.com/malcommac/SwiftRichString")),
        SourceInfo(title: "SwiftyMarkdown", url: URL(string: "https://github.com/SimonFairbairn/SwiftyMarkdown")),
        SourceInfo(title: "SwiftyStoreKit", url: URL(string: "https://github.com/bizz84/SwiftyStoreKit")),
    ]

    private let appModels: [SourceInfo] = [
        SourceInfo(title: L10n.About.Support.writeToEmail, url: URL(string: "mailto:azkar.app@pm.me")!, openUrlInApp: false),
        SourceInfo(title: L10n.Common.shareApp, openUrlInApp: false, action: {
            let url = URL(string: "https://itunes.apple.com/app/id1511423586")!
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activity, animated: true, completion: nil)
        }),
        SourceInfo(title: L10n.About.Support.leaveReview, url: URL(string: "https://itunes.apple.com/app/id1511423586?action=write-review&mt=8")!, openUrlInApp: false),
    ]

    private let studioModels: [SourceInfo] = [
        SourceInfo(title: L10n.About.Studio.telegramChannel, url: URL(string: "https://telegram.me/jawziyya")!, openUrlInApp: false),
        SourceInfo(title: L10n.About.Studio.instagramPage, url: URL(string: "https://instagram.com/jawziyya.studio"), openUrlInApp: false),
        SourceInfo(title: L10n.About.Studio.jawziyyaApps, url: URL(string: "https://apps.apple.com/ru/developer/al-jawziyya/id1165327318")!, openUrlInApp: false)
    ]

    init(preferences: Preferences) {
        iconImageName = preferences.appIcon.imageName

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!

        appVersion = "\(L10n.Common.version) \(version) (\(build))"

        let materialsCreditsSection = Section(
            header: L10n.About.Credits.sourcesHeader,
            items: materialsCredits)

        let graphicMaterialsSection = Section(
            header: L10n.About.Credits.graphicsHeader,
            items: graphicMaterialsCredits
        )

        let openSourceLibrariesSection = Section(
            header: L10n.About.Credits.openSourceLibrariesHeader,
            items: openSourceLibraries
        )

        let supportAndFeedbackSection = Section(
            header: L10n.About.Support.header,
            items: appModels
        )

        let studioSection = Section(
            header: L10n.About.Studio.header,
            items: studioModels
        )

        sections = [
            materialsCreditsSection,
            supportAndFeedbackSection,
            studioSection,
            graphicMaterialsSection,
            openSourceLibrariesSection,
        ]
    }

}
