// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Combine
import Entities
import AzkarServices

public actor InMemoryZikrCounter: ZikrCounterType {
    
    private var date = Date()
    private var data: [Zikr: Int] = [:]
    private let completedRepeatsSubject = CurrentValueSubject<[ZikrCategory: Int], Never>([:])
    
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
        
        if let category = zikr.category {
            await updateCompletedRepeats(for: category)
        }
    }
    
    nonisolated public func observeRemainingRepeats(for zikr: Entities.Zikr) -> AnyPublisher<Int, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    public func markCategoryAsCompleted(_ category: ZikrCategory) async throws {
        // When marking a category as completed, update its completed repeats
        let totalRepeats = await calculateTotalRepeats(in: category)
        var currentValues = completedRepeatsSubject.value
        currentValues[category] = totalRepeats
        completedRepeatsSubject.send(currentValues)
    }

    nonisolated public func observeCompletedRepeats(in category: ZikrCategory) -> AnyPublisher<Int, Never> {
        return completedRepeatsSubject
            .map { categoryValues in
                categoryValues[category] ?? 0
            }
            .eraseToAnyPublisher()
    }
    
    public func isCategoryMarkedAsCompleted(_ category: ZikrCategory) async -> Bool {
        return false
    }
    
    private func resetDataIfNeeded() {
        guard Calendar.current.isDateInToday(date) == false else {
            return
        }
        date = Date()
        data = [:]
        completedRepeatsSubject.send([:])
    }
    
    private func calculateTotalRepeats(in category: ZikrCategory) -> Int {
        let zikrsInCategory = data.keys.filter { $0.category == category }
        let totalRepeats = zikrsInCategory.reduce(0) { sum, zikr in
            let originalRepeats = zikr.repeats
            let remainingRepeats = data[zikr] ?? originalRepeats
            return sum + (originalRepeats - remainingRepeats)
        }
        return totalRepeats
    }
    
    private func updateCompletedRepeats(for category: ZikrCategory) async {
        let completedCount = await calculateTotalRepeats(in: category)
        var currentValues = completedRepeatsSubject.value
        currentValues[category] = completedCount
        completedRepeatsSubject.send(currentValues)
    }
    
    public func resetCategoryCompletionMark(_ category: ZikrCategory) async {
        var currentValues = completedRepeatsSubject.value
        currentValues[category] = 0
        completedRepeatsSubject.send(currentValues)
        data = data.filter { $0.key.category != category }
    }
    
}
