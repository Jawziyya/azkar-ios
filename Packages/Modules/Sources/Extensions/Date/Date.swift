//
//
//  Azkar
//  
//  Created on 14.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation

private let hijriCalendar = Calendar(identifier: .islamicUmmAlQura)

public let muharram = 1
public let safar = 2
public let rabiAwwal = 3
public let rabiSani = 4
public let jumadaUla = 5
public let jumadaAkhira = 6
public let rajab = 7
public let shaban = 8
public let ramadan = 9
public let shawwal = 10
public let zulQada = 11
public let zulHijja = 12

public extension Date {

    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var hijriYear: Int {
        return hijriCalendar.component(.year, from: self)
    }

    var isRamadan: Bool {
        hijriCalendar.component(.month, from: self) == ramadan
    }

    /// Returns wheter current date fits in 'end of sha'ban beginning of ramadan' range.
    var isBeginningOfRamadan: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == shaban && 27...30 ~= day) || (month == ramadan && 1...3 ~= day)
    }

    /// Returns wheter current date fits in 'end of ramadan beginning of shawwal' range.
    var isEndOfRamadan: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == ramadan && 27...30 ~= day) || (month == shawwal && 1...3 ~= day)
    }

    /// Returns wheter current date fits in ramadan eid days.
    /// The value is approximate and actual date can be different.
    var isRamadanEidDays: Bool {
        let components = hijriCalendar.dateComponents([.month, .day], from: self)
        guard let day = components.day, let month = components.month else {
            return false
        }
        return (month == ramadan && 29...30 ~= day) || (month == shawwal && 1...3 ~= day)
    }

}
