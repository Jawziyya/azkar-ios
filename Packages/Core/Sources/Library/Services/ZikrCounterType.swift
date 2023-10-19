// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation
import Entities

public protocol ZikrCounterType: AnyObject {
    func getRemainingRepeats(for zikr: Zikr) async -> Int
    func incrementCounter(for zikr: Zikr) async throws
}
