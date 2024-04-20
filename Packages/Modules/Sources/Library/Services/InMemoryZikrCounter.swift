// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities

public actor InMemoryZikrCounter: ZikrCounterType {
    
    private var date = Date()
    private var data: [Zikr: Int] = [:]
    
    public init() {}
    
    public func getRemainingRepeats(for zikr: Zikr) async -> Int {
        resetDataIfNeeded()
        
        if let repeats = data[zikr] {
            return repeats
        }
        return zikr.repeats
    }
    
    public func incrementCounter(for zikr: Zikr) async throws {
        resetDataIfNeeded()
        
        let repeats: Int
        if let count = data[zikr] {
            repeats = count
        } else {
            repeats = zikr.repeats
        }
        data[zikr] = repeats - 1
    }
    
    private func resetDataIfNeeded() {
        guard Calendar.current.isDateInToday(date) == false else {
            return
        }
        date = Date()
        data = [:]
    }
    
}
