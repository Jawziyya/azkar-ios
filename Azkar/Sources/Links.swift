// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import Foundation
import Entities
import Library

typealias Hadith = Entities.Hadith
typealias Zikr = Entities.Zikr
typealias ZikrCategory = Entities.ZikrCategory
typealias Fadl = Entities.Fadl
typealias AudioTiming = Entities.AudioTiming

var languageIdentifier: LangId {
    Entities.languageIdentifier
}

typealias DatabaseService = Library.DatabaseService