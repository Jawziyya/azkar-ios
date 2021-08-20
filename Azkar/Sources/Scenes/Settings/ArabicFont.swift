//
//  ArabicFont.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 13.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum ArabicFont: String, CaseIterable, Identifiable, Codable, Hashable, PickableItem {
    case standard, adobe, KFGQP, noto, scheherazade

    var fontName: String {
        switch self {
        case .standard:
            return ""
        case .adobe:
            return "AdobeArabic-Regular"
        case .KFGQP:
            return "KFGQPCUthmanicScriptHAFS"
        case .noto:
            return "NotoNaskhArabicUI"
        case .scheherazade:
            return "Scheherazade"
        }
    }

    var id: String {
        return rawValue
    }

    var title: String {
        switch self {
        case .standard:
            return NSLocalizedString("settings.text.standard-font-name", comment: "")
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
        return "باسم الله"
    }

    var subtitleFont: Font {
        return Font.custom(fontName, size: textSize(forTextStyle: .callout))
    }

}
