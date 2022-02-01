// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import SwiftUI

typealias ZikrID = Int

protocol ZikrCounterServiceType {
    func getRemainingRepeats(for zikr: Zikr) -> Int
    func incrementCounter(for zikr: Zikr)
}

final class ZikrCounterService: ZikrCounterServiceType {

    struct AzkarCounterData: Codable {
        var data: [ZikrID: Int]
    }

    @Preference(Keys.azkarCounter, defaultValue: AzkarCounterData(data: [:]))
    var counter: AzkarCounterData

    @Preference(Keys.azkarCounterLastChangeDate, defaultValue: Date())
    var lastChangeTimestamp: Date

    private let calendar = Calendar.current

    private func resetCounterIfNeeded() {
        if calendar.isDateInToday(lastChangeTimestamp) == false {
            counter = .init(data: [:])
        }
        lastChangeTimestamp = .init()
    }

    func getRemainingRepeats(for zikr: Zikr) -> Int {
        resetCounterIfNeeded()
        let completedRepeats = counter.data[zikr.id, default: 0]
        return max(0, zikr.repeats - completedRepeats)
    }

    func incrementCounter(for zikr: Zikr) {
        resetCounterIfNeeded()
        let old = counter.data[zikr.id, default: 0]
        counter.data[zikr.id] = old + 1
    }

}
