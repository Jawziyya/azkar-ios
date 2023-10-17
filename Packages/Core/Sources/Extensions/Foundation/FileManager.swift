// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

public extension FileManager {
    
    var applicationSupportDirectoryURL: URL {
        urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    }
    
    var fontsDirectoryURL: URL {
        applicationSupportDirectoryURL.appendingPathComponent("fonts")
    }
    
    var appGroupContainerURL: URL {
        containerURL(forSecurityApplicationGroupIdentifier: "group.io.jawziyya.azkar-app")!
    }
    
}
