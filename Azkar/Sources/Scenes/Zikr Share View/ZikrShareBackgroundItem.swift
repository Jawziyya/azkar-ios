// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import SwiftUI
import Library

struct ZikrShareBackgroundItem: Identifiable, Hashable {
    let id: String
    let backgroundType: BackgroundType
    var isProItem = true
    
    static let defaultBackground = ZikrShareBackgroundItem(id: "main_bg_color", backgroundType: .solidColor(.background), isProItem: false)
    
    private static let patternImageNames: [String] = [
        "blue-gradient",
        "paper",
        "paper2",
    ]
    
    static var patternImages: [ZikrShareBackgroundItem] {
        patternImageNames.map {
            ZikrShareBackgroundItem(
                id: $0,
                backgroundType: .localImage(UIImage(named: "Patterns/" + $0)!),
                isProItem: false
            )
        }
    }
    
    static var preset: [ZikrShareBackgroundItem] {
        [defaultBackground] + patternImages
    }
    
    enum BackgroundType: Hashable {
        case solidColor(ColorType)
        case localImage(UIImage)
        case remoteImage(ShareBackground)
    }
    
}
