// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import Combine

public protocol ZikrCounterType: AnyObject {
    func getRemainingRepeats(for zikr: Zikr) async -> Int?
    func markCategoryAsCompleted(_ category: ZikrCategory) async throws
    func incrementCounter(for zikr: Zikr) async throws
    func incrementCounter(for zikr: Zikr, by count: Int) async throws
    func observeCompletedRepeats(in category: ZikrCategory) -> AnyPublisher<Int, Never>
    func isCategoryCompleted(_ category: ZikrCategory) async -> Bool
    func resetCounterForCategory(_ category: ZikrCategory) async
    func resetCategoryCompletionMark(_ category: ZikrCategory) async
}
