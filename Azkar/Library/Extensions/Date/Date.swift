//
//
//  Azkar
//  
//  Created on 14.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation

private let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)

extension Date {

    var year: Int {
        Calendar.init(identifier: .gregorian).component(.year, from: self)
    }

    var hijriYear: Int {
        return hijriCalendar.component(.year, from: self)
    }

    /// Returns wheter current date fits in 'end of sha'ban beginning of ramadan' range.
    var isBeginningOfRamadan: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == 8 && 27...30 ~= day) || (month == 9 && 1...3 ~= day)
    }

    /// Returns wheter current date fits in 'end of ramadan beginning of shawwal' range.
    var isEndOfRamadan: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == 9 && 27...30 ~= day) || (month == 10 && 1...3 ~= day)
    }

    /// Returns wheter current date fits in ramadan eid days.
    /// The value is approximate and actual date can be different.
    var isRamadanEidDays: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == 8 && 27...30 ~= day) || (month == 9 && 1...3 ~= day)
    }

}
