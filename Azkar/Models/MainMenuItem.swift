//
//  MainMenuItem.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

enum MainMenuItem: String, CaseIterable, Identifiable {
    case morning, evening, bedtime, quranic, afterPrayer, favorites

    var title: String {
        return rawValue.capitalized
    }

    var localizedTitle: String {
        return NSLocalizedString("category." + rawValue, comment: "")
    }

    var imageName: String {
        switch self {
        case .morning:
            return "sun.max.fill"
        case .evening:
            return "moon.stars.fill"
        case .favorites:
            return "heart"
        case .bedtime:
            return "bed.double"
        case .afterPrayer:
            return "list.dash"
        case .quranic:
            return "book.circle"
        }
    }

    var id: String {
        return rawValue
    }
}
