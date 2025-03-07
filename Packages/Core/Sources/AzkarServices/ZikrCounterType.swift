// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities
import Combine

public protocol ZikrCounterType: AnyObject {
    func observeRemainingRepeats(for zikr: Zikr) -> AnyPublisher<Int, Never>
    func getRemainingRepeats(for zikr: Zikr) async -> Int
    func incrementCounter(for zikr: Zikr) async throws
}
