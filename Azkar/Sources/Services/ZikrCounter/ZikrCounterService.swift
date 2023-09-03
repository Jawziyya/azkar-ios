// Copyright © 2022 Al Jawziyya. All rights reserved. 

import Foundation
import Library

protocol ZikrCounterServiceType: AnyObject {
    func getRemainingRepeats(for zikr: Zikr) async -> Int
    func incrementCounter(for zikr: Zikr) async throws
}

extension CounterDatabaseService: ZikrCounterServiceType {}
