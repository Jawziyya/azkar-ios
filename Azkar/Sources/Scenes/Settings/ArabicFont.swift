//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI

struct ArabicFont: AppFont, Identifiable, Codable, Hashable {
    
    enum FontType: Int, Codable, AppFontStyle {
        case naskh = 0, riqa = 1, thuluth = 2, kufi = 3, maghribi = 4, modern = 5, other = 6
        
        var key: String {
            switch self {
            case .naskh: return "arabic.naskh"
            case .riqa: return "arabic.riqa"
            case .thuluth: return "arabic.thuluth"
            case .kufi: return "arabic.kufi"
            case .maghribi: return "arabic.maghribi"
            case .modern: return "arabic.modern"
            case .other: return "arabic.other"
            }
        }
    }
    
    var id: String {
        postscriptName
    }
    
    var style: AppFontStyle {
        type
    }
    
    var name: String
    
    var referenceName: String = STANDARD_FONT_REFERENCE_NAME
    
    var postscriptName: String
    
    var sizeAdjustment: Float?
    
    var lineAdjustment: Float?
    
    var type: FontType = .naskh
    
    private var supportsTashkeel: Int? = 1
    
    var hasTashkeelSupport: Bool {
        supportsTashkeel == 1
    }
    
}

extension ArabicFont {
    
    static var standardFonts: [AppFont] {
        [systemArabic, adobe, KFGQP, noto]
    }
    
    static var systemArabic: ArabicFont {
        ArabicFont(name: L10n.Settings.Text.standardFontName, postscriptName: "")
    }
    
    static var adobe: ArabicFont {
        ArabicFont(name: "Adobe", postscriptName: "AdobeArabic-Regular")
    }
    
    static var KFGQP: ArabicFont {
        ArabicFont(name: "KFGQP", postscriptName: "KFGQPCUthmanicScriptHAFS")
    }
    
    static var noto: ArabicFont {
        ArabicFont(name: "Noto Naskh", postscriptName: "NotoNaskhArabicUI")
    }
    
}
