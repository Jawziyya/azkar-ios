// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities

public actor InMemoryZikrCounter: ZikrCounterType {
    
    private var data: [Zikr: Int] = [:]
    
    public init() {}
    
    public func getRemainingRepeats(for zikr: Zikr) async -> Int {
        if let repeats = data[zikr] {
            return repeats
        }
        return zikr.repeats
    }
    
    public func incrementCounter(for zikr: Zikr) async throws {
        let repeats: Int
        if let count = data[zikr] {
            repeats = count
        } else {
            repeats = zikr.repeats
        }
        data[zikr] = repeats - 1
    }
    
}
