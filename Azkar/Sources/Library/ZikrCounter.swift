// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Combine
import Library
import Entities
import AzkarServices
import DatabaseInteractors

private func getKey(for date: Date) -> Int {
    let startOfDay = Calendar.current.startOfDay(for: date)
    return Int(startOfDay.timeIntervalSince1970)
}

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
                getKey(for: Date())
            }
        )
    }
    
    func getRemainingRepeats(for zikr: Zikr) async -> Int {
        await inMemoryZikrCounter.getRemainingRepeats(for: zikr)
    }
    
    func observeRemainingRepeats(for zikr: Zikr) -> AnyPublisher<Int, Never> {
        databaseZikrCounter.observeRemainingRepeats(for: zikr)
    }
    
    func incrementCounter(for zikr: Zikr) async throws {
        try await inMemoryZikrCounter.incrementCounter(for: zikr)
        try await databaseZikrCounter.incrementCounter(for: zikr)
    }
    
}
