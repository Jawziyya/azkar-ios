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
    let url: URL
    var openUrlInApp = true
    var imageName: String?
    var imageType: IconType = .bundled

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

    let legalInfoHeader = """
    Перевод, транскрипция, аудиофайлы озвучки
    """

    let imagesInfoHeader = """
    Графические материалы и шрифты
    """

    let supportHeader = """
    Обратная связь
    """

    let azkarLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: "azkar.ru", url: URL(string: "https://azkar.ru")!),
    ]

    let imagesLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: "Изображение значка (flaticon.com)", url: URL(string: "https://flaticon.com/free-icon/moon_414942?term=moon&page=1&position=17")!, imageName: nil),
        SourceInfo(title: "Шрифт Adobe Arabic", url: URL(string: "https://fonts.adobe.com/fonts/adobe-arabic")!, imageName: nil),
        SourceInfo(title: "Шрифт Комплекса имени Короля Фахда по изданию Священного Корана", url: URL(string: "https://qurancomplex.gov.sa/en/")!, imageName: nil),
        SourceInfo(title: "Шрифт Google Noto Naskh", url: URL(string: "https://www.google.com/get/noto/#naskh-arab")!, imageName: nil),
        SourceInfo(title: "Шрифт Scheherazade", url: URL(string: "https://software.sil.org/scheherazade/")!, imageName: nil),
    ]

    let supportModels: [SourceInfo] = [
        SourceInfo(title: "Написать на эл. почту", url: URL(string: "mailto:azkar.app@pm.me")!, openUrlInApp: false),
        SourceInfo(title: "Оставить отзыв", url: URL(string: "https://itunes.apple.com/app/id1511423586?action=write-review&mt=8")!, openUrlInApp: false),
        SourceInfo(title: "Канал в Telegram", url: URL(string: "https://telegram.me/jawziyya")!, openUrlInApp: false),
        SourceInfo(title: "Приложения от Jawziyya 🥜", url: URL(string: "https://apps.apple.com/ru/developer/al-jawziyya/id1165327318")!, openUrlInApp: false)
    ]

    init() {
        if let name = UIApplication.shared.alternateIconName {
            iconImageName = "ic_\(name).png"
        } else {
            iconImageName = "ic_light.png"
        }

        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")!
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion")!

        appVersion = "Версия \(version) (\(build))"
    }

}
