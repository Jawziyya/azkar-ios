//
//  SettingsViewModel.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

enum ArabicFont: String, CaseIterable, Identifiable, Codable, Hashable, PickableItem {
    case standard, adobe, amiri, KFGQP, noto, scheherazade

    var fontName: String {
        switch self {
        case .standard:
            return "iOS"
        case .adobe:
            return ArabicFonts.adobe
        case .amiri:
            return "Amiri"
        case .KFGQP:
            return ArabicFonts.KFGQP
        case .noto:
            return ArabicFonts.noto
        case .scheherazade:
            return ArabicFonts.scheherazade
        }
    }

    var id: String {
        return rawValue
    }

    var title: String {
        switch self {
        case .adobe:
            return rawValue.capitalized
        case .KFGQP:
            return rawValue
        case .noto:
            return "Noto Nashkh"
        default:
            return fontName
        }
    }

    var subtitle: String? {
        return "بسم الله"
    }

    var subtitleFont: Font {
        return Font.custom(fontName, size: textSize(forTextStyle: .callout))
    }

}

enum Theme: Int, Codable, CaseIterable, Identifiable, PickableItem, Hashable {
    case automatic, light, dark

    var id: Int {
        return rawValue
    }

    var title: String {
        switch self {
        case .automatic:
            return "Авто"
        case .light:
            return "Светлая"
        case .dark:
            return "Тёмная"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }

    var statusBarStyle: UIStatusBarStyle? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .darkContent
        case .dark:
            return .lightContent
        }
    }

    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

}

enum AppIcon: String, CaseIterable, Hashable, PickableItem, Identifiable {
    case light, ink, dark, ramadan = "purple"

    static var availableIcons: [AppIcon] {
        return Array(allCases.prefix(3))
    }

    var iconName: String? {
        switch self {
        case .light:
            return nil
        default:
            return rawValue
        }
    }

    var title: String {
        switch self {
        case .light:
            return "Золото"
        case .ink:
            return "Чернила"
        case .dark:
            return "Тёмная ночь"
        case .ramadan:
            return "Рамадан"
        }
    }

    var id: String {
        rawValue
    }

    var image: Image? {
        Image(uiImage: UIImage(named: "ic_\(rawValue).png")!)
    }
}

final class SettingsViewModel: ObservableObject {

    var preferences: Preferences

    var canChangeIcon: Bool {
        #if os(iOS)
        return true
        #else
        return false
        #endif
    }

    @Published var arabicFont: ArabicFont
    @Published var theme: Theme
    @Published var appIcon: AppIcon = .ink

    private var cancellabels = Set<AnyCancellable>()

    init(preferences: Preferences) {
        self.preferences = preferences
        arabicFont = preferences.arabicFont
        theme = preferences.theme

        preferences.objectWillChange
            .receive(on: RunLoop.main)
            .map { _ in preferences.arabicFont }
            .assign(to: \.arabicFont, on: self)
            .store(in: &cancellabels)

        preferences.objectWillChange
            .receive(on: RunLoop.main)
            .map { _ in preferences.theme }
            .assign(to: \.theme, on: self)
            .store(in: &cancellabels)

        $appIcon
            .dropFirst(1)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { icon in
                UIApplication.shared.setAlternateIconName(icon.iconName)
            })
            .store(in: &cancellabels)
    }

}
