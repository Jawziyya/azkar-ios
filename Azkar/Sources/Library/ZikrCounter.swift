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
        
    func markCategoryAsCompleted(_ category: ZikrCategory) async throws {
        switch category {
        case .afterSalah:
            try await inMemoryZikrCounter.markCategoryAsCompleted(category)
        case .morning, .evening, .night:
            try await databaseZikrCounter.markCategoryAsCompleted(category)
        default:
            break
        }
    }
    
    func incrementCounter(for zikr: Zikr) async throws {
        try await inMemoryZikrCounter.incrementCounter(for: zikr)
        try await databaseZikrCounter.incrementCounter(for: zikr)
    }
    
    func observeCompletedRepeats(in category: ZikrCategory) -> AnyPublisher<Int, Never> {
        if category == .afterSalah {
            return inMemoryZikrCounter.observeCompletedRepeats(in: category)
        } else {
            return databaseZikrCounter.observeCompletedRepeats(in: category)
        }
    }
    
    func isCategoryMarkedAsCompleted(_ category: ZikrCategory) async -> Bool {
        if category == .afterSalah {
            return await inMemoryZikrCounter.isCategoryMarkedAsCompleted(category)
        } else {
            return await databaseZikrCounter.isCategoryMarkedAsCompleted(category)
        }
    }
    
    func resetCategoryCompletionMark(_ category: ZikrCategory) async {
        await inMemoryZikrCounter.resetCategoryCompletionMark(category)
        await databaseZikrCounter.resetCategoryCompletionMark(category)
    }
    
}
