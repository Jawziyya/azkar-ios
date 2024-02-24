// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

public extension String {
    var textOrNil: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return nil
        } else {
            return trimmed
        }
    }
}
