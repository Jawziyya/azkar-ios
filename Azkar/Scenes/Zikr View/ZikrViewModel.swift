//
//  ZikrViewModel.swift
//  Azkar
//
//  Created by Al Jawziyya on 07.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class ZikrViewModel: ObservableObject, Identifiable, Equatable, Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(zikr)
    }

    static func == (lhs: ZikrViewModel, rhs: ZikrViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    var id: String {
        title
    }

    let zikr: Zikr
    let title: String
    var text: String {
        preferences.showTashkeel ? zikr.text : zikr.text.trimmingArabicVowels
    }
    let preferences: Preferences

    var playerViewModel: PlayerViewModel?
    var hadithViewModel: HadithViewModel?

    @Published var expandTranslation: Bool
    @Published var expandTransliteration: Bool

    private var cancellabels: [AnyCancellable] = []

    init(zikr: Zikr, preferences: Preferences, player: Player) {
        self.zikr = zikr
        self.preferences = preferences
        title = zikr.title ?? "\(NSLocalizedString("common.zikr", comment: "")) №\(zikr.rowInCategory)"

        expandTranslation = preferences.expandTranslation
        expandTransliteration = preferences.expandTransliteration

        if let url = zikr.audioURL {
            playerViewModel = PlayerViewModel(title: title, subtitle: zikr.category.title, audioURL: url, player: player)
        }

        #if SHOW_AZKAR_SOURCES
        if zikr.hadith != nil {
            hadithViewModel = HadithViewModel(zikrViewModel: self, preferences: preferences)
        }
        #endif

        cancellabels = [
            preferences.$expandTranslation.assign(to: \.expandTranslation, on: self),
            preferences.$expandTransliteration.assign(to: \.expandTransliteration, on: self)
        ]
    }

    func getText() -> NSAttributedString {
        let string = self.text
        let fontName = preferences.arabicFont.fontName
        let size = textSize(forTextStyle: .title1, contentSizeCategory: preferences.sizeCategory.uiContentSizeCategory)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = .center

        let font = UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)

        let text = NSMutableAttributedString(
            string: string,
            attributes: [
                .font: font,
                .foregroundColor: UIColor(Color.text),
                .paragraphStyle: paragraphStyle
            ]
        )

        if fontName == ArabicFont.KFGQP.fontName {
            let regex = try! NSRegularExpression(pattern: "،", options: [])
            regex.enumerateMatches(in: string, options: [], range: string.nsRange) { result, _, _ in
                if let range = result?.range {
                    text.addAttribute(.font, value: UIFont(name: ArabicFont.adobe.fontName, size: size)!, range: range)
                }
            }
        }

        return text
    }

}
