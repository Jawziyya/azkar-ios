// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation

struct SubscriptionManagerFactory {
    
    private static let sharedInstance = SubscriptionManager.shared
    private static let sharedDemoInstance = DemoSubscriptionManager()
    
    static func create() -> SubscriptionManagerType {
        if CommandLine.arguments.contains("DEMO_SUBSCRIPTION") {
            return sharedDemoInstance
        } else {
            return sharedInstance
        }
    }
    
}
