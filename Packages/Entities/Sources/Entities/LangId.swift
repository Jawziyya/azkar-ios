// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

extension Bundle {
    
    var currentLocalizedUILanguageCode: String {
        guard let code = Bundle.main.preferredLocalizations.first?.components(separatedBy: "-").first else {
            return Locale.current.languageCode ?? "en"
        }
        return code
    }
    
}

public var languageIdentifier: LangId {
    let id = Bundle.main.currentLocalizedUILanguageCode.lowercased()
    switch id {
    case _ where id.hasPrefix("ar"): return .ar
    case _ where id.hasPrefix("tr"): return .tr
    case _ where id.hasPrefix("ru"): return .ru
    default: return .en
    }
}

public enum LangId: String {
    case ar, tr, en, ru
}
