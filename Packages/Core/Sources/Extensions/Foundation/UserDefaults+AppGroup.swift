// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

public extension UserDefaults {
    
    static var appGroup: UserDefaults {
        UserDefaults(suiteName: "group.io.jawziyya.azkar-app") ?? .standard
    }
    
}
