// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Library
import Entities

final class ZikrCounter: ZikrCounterType {
    
    private let inMemoryZikrCounter: ZikrCounterType
    private let databaseZikrCounter: ZikrCounterType
    
    static let shared = ZikrCounter()
    
    init() {
        inMemoryZikrCounter = InMemoryZikrCounter()
        databaseZikrCounter = DatabaseZikrCounter(
            databasePath: FileManager.default
                .appGroupContainerURL
                .appendingPathComponent("counter.db")
                .absoluteString,
            getKey: {
                let startOfDay = Calendar.current.startOfDay(for: Date())
                return Int(startOfDay.timeIntervalSince1970)
            }
        )
    }
    
    func getRemainingRepeats(for zikr: Zikr) async -> Int {
        await inMemoryZikrCounter.getRemainingRepeats(for: zikr)
    }
    
    func incrementCounter(for zikr: Zikr) async throws {
        try await inMemoryZikrCounter.incrementCounter(for: zikr)
        try await databaseZikrCounter.incrementCounter(for: zikr)
    }
    
}
