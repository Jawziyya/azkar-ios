// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

var languageIdentifier: LangId {
    let id = Locale.preferredLanguages[0]
    switch id {
    case _ where id.hasPrefix("ar"): return .ar
    case _ where id.hasPrefix("tr"): return .tr
    case _ where id.hasPrefix("ru"): return .ru
    default: return .en
    }
}

enum LangId: String {
    case ar, tr, en, ru
}
