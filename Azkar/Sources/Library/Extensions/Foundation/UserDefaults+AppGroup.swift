// Copyright © 2023 Azkar
// All Rights Reserved.

import Foundation

extension UserDefaults {
    
    static var appGroup: UserDefaults {
        UserDefaults(suiteName: "group.io.jawziyya.azkar-app") ?? .standard
    }
    
}
