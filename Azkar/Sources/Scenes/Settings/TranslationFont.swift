// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

struct TranslationFont: Codable, Identifiable, Hashable, AppFont {
    
    enum FontType: Int, Codable, Equatable, AppFontStyle {
        case serif, sansSerif, handwritten, decorative, additional
        
        var key: String {
            "\(self)"
        }
    }
    
    var id: String {
        postscriptName
    }
    
    var style: AppFontStyle {
        type
    }
    
    let name: String
    var referenceName: String = STANDARD_FONT_REFERENCE_NAME
    let postscriptName: String
    var type: FontType = .serif
    private var isCyrillic: Int?
    var sizeAdjustment: Float?
    var lineAdjustment: Float?
    
    var supportsCyryllicCharacters: Bool {
        isCyrillic == 1
    }
    
    static var placeholder: TranslationFont {
        return TranslationFont(
            name: UUID().uuidString,
            referenceName: UUID().uuidString,
            postscriptName: "test",
            type: FontType.serif,
            isCyrillic: 1
        )
    }
}

extension TranslationFont {
    
    static var standardFonts: [TranslationFont] {
        [systemFont, courier, iowanOldStyle, baskerville]
    }
    
    static var systemFont: TranslationFont {
        TranslationFont(name: L10n.Fonts.standardFont, postscriptName: "", type: .sansSerif, isCyrillic: 1)
    }
    
    static var courier: TranslationFont {
        TranslationFont(name: "Courier New", postscriptName: "CourierNewPSMT", isCyrillic: 1)
    }
    
    static var iowanOldStyle: TranslationFont {
        TranslationFont(name: "Iowan Old Style", postscriptName: "IowanOldStyle-Roman", isCyrillic: 1)
    }
    
    static var baskerville: TranslationFont {
        TranslationFont(name: "Baskerville", postscriptName: "Baskerville", isCyrillic: 1)
    }
    
}
