// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

struct AppFont: Codable, Identifiable, Equatable, Hashable {
    
    enum FontType: Int, Codable, Equatable {
        case serif, sansSerif, handwritten, decorative
    }
    
    var id: String {
        referenceName
    }
    
    let name: String
    var referenceName: String = AppFont.defaultFontName
    let postscriptName: String
    var type: FontType = .serif
    let isCyrillic: Int
    var sizeAdjustment: Float?
    
    var supportsCyryllicCharacters: Bool {
        isCyrillic != 0
    }
    
    static var placeholder: AppFont {
        return AppFont(
            name: UUID().uuidString,
            referenceName: UUID().uuidString,
            postscriptName: "test",
            type: FontType.serif,
            isCyrillic: 1
        )
    }
}

extension AppFont {
    
    static var defaultFontName: String {
        "standard-font-reference-name"
    }
    
    static var standardFonts: [AppFont] {
        [systemFont, .courier, iowanOldStyle, baskerville]
    }
    
    static var systemFont: AppFont {
        AppFont(name: L10n.Fonts.standardFont, postscriptName: "", type: .sansSerif, isCyrillic: 1)
    }
    
    static var courier: AppFont {
        AppFont(name: "Courier New", postscriptName: "CourierNewPSMT", isCyrillic: 1)
    }
    
    static var iowanOldStyle: AppFont {
        AppFont(name: "Iowan Old Style", postscriptName: "IowanOldStyle-Roman", isCyrillic: 1)
    }
    
    static var baskerville: AppFont {
        AppFont(name: "Baskerville", postscriptName: "Baskerville", isCyrillic: 1)
    }
    
}
