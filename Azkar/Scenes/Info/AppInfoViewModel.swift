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
    var imageName: String?

    var id: String { title }
}

struct AppInfoViewModel {

    enum Section {
        case versionAndName
        case azkarLegal
        case imagesLegal
    }

    let appVersion: String

    let iconImageName: String

    let legalInfoHeader = """
    Перевод, транскрипция, аудиофайлы озвучки
    """

    let imagesInfoHeader = """
    Графические материалы и шрифты
    """

    let azkarLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: "azkar.ru", url: URL(string: "https://azkar.ru")!),
    ]

    let imagesLegalInfoModels: [SourceInfo] = [
        SourceInfo(title: "Изображение flaticon.com/moon_414942", url: URL(string: "https://www.flaticon.com/free-icon/moon_414942?term=moon&page=1&position=17")!, imageName: nil),
        SourceInfo(title: "Шрифт Adobe Arabic", url: URL(string: "https://fonts.adobe.com/fonts/adobe-arabic")!, imageName: nil),
        SourceInfo(title: "Шрифт Amiri", url: URL(string: "https://www.amirifont.org")!, imageName: nil),
        SourceInfo(title: "Шрифт Комплекса имени Короля Фахда по изданию Священного Корана", url: URL(string: "https://qurancomplex.gov.sa/en/")!, imageName: nil),
        SourceInfo(title: "Шрифт Google Noto Naskh", url: URL(string: "https://www.google.com/get/noto/#naskh-arab")!, imageName: nil),
        SourceInfo(title: "Шрифт Scheherazade", url: URL(string: "https://software.sil.org/scheherazade/")!, imageName: nil),
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
