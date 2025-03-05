// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import Foundation
import Entities
import Library
import AzkarServices
import DatabaseInteractors

typealias Hadith = Entities.Hadith
typealias Zikr = Entities.Zikr
typealias ZikrCategory = Entities.ZikrCategory
typealias Fadl = Entities.Fadl
typealias AudioTiming = Entities.AudioTiming

typealias AzkarDatabase = DatabaseInteractors.AdhkarSQLiteDatabaseService
typealias PreferencesDatabase = AzkarServices.PreferencesDatabaseService
typealias Preference = Entities.Preference
