// Copyright © 2022 Al Jawziyya. All rights reserved.

import Foundation
import SwiftUI
import Library

extension ZikrShareBackgroundItem {

    static let defaultBackground = ZikrShareBackgroundItem(
        id: ColorType.background.rawValue,
        background: .solidColor(.background),
        type: .color,
        isProItem: false
    )
    
    private static let colorTypes: [ColorType] = [
        .contentBackground,
        .accent,
    ]
    
    static var colors: [ZikrShareBackgroundItem] {
        colorTypes.map {
            ZikrShareBackgroundItem(
                id: $0.rawValue,
                background: .solidColor($0),
                type: .color,
                isProItem: false
            )
        }
    }
    
    private static let patternImageNames: [String] = [
        "blue-gradient",
        "paper",
        "paper2",
    ]
    
    static var patternImages: [ZikrShareBackgroundItem] {
        patternImageNames.map {
            ZikrShareBackgroundItem(
                id: $0,
                background: .localImage(UIImage(named: "Patterns/" + $0, in: resourcesBunbdle, with: nil)!),
                type: .pattern,
                isProItem: false
            )
        }
    }
    
    static var preset: [ZikrShareBackgroundItem] {
        [defaultBackground] + colors + patternImages
    }
    
}
