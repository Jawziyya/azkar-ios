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

final class ZikrCounter: ObservableObject, ZikrCounterType {
    
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
    
    func getRemainingRepeats(for zikr: Zikr) async -> Int? {
        guard zikr.category != .other else {
            return nil
        }
        return await databaseZikrCounter.getRemainingRepeats(for: zikr)
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
    
    func incrementCounter(for zikr: Zikr, by count: Int) async throws {
        try await inMemoryZikrCounter.incrementCounter(for: zikr, by: count)
        try await databaseZikrCounter.incrementCounter(for: zikr, by: count)
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
    
    func resetCounterForCategory(_ category: ZikrCategory) async {
        await inMemoryZikrCounter.resetCounterForCategory(category)
        await inMemoryZikrCounter.resetCategoryCompletionMark(category)
        await databaseZikrCounter.resetCounterForCategory(category)
        await databaseZikrCounter.resetCategoryCompletionMark(category)
    }
    
    func resetCategoryCompletionMark(_ category: ZikrCategory) async {
        await inMemoryZikrCounter.resetCategoryCompletionMark(category)
        await databaseZikrCounter.resetCategoryCompletionMark(category)
    }
    
}
