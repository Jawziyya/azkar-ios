// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import Combine

public protocol ZikrCounterType: AnyObject {
    func getRemainingRepeats(for zikr: Zikr) async -> Int
    func markCategoryAsCompleted(_ category: ZikrCategory) async throws
    func incrementCounter(for zikr: Zikr) async throws
    func observeCompletedRepeats(in category: ZikrCategory) -> AnyPublisher<Int, Never>
    func isCategoryMarkedAsCompleted(_ category: ZikrCategory) async -> Bool
    func resetCategoryCompletionMark(_ category: ZikrCategory) async
}
