// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import SwiftUI

protocol ZikrCounterServiceType: AnyObject {
    func getRemainingRepeats(for zikr: Zikr) async -> Int
    func incrementCounter(for zikr: Zikr) async
}

actor ZikrCounterService: ZikrCounterServiceType {

    struct AzkarCounterData: Codable {
        var data: [Zikr.ID: Int]
    }
    
    init() {
        Task {
            await resetCounterIfNeeded()
        }
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
        lastChangeTimestamp = Date()
    }

    func getRemainingRepeats(for zikr: Zikr) async -> Int {
        let completedRepeats = counter.data[zikr.id, default: 0]
        return max(0, zikr.repeats - completedRepeats)
    }

    func incrementCounter(for zikr: Zikr) async {
        resetCounterIfNeeded()
        let old = counter.data[zikr.id, default: 0]
        counter.data[zikr.id] = old + 1
    }

}
