// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine
import StoreKit

enum UserRegion: String, Hashable {
    case russia = "RUS"
    case usa = "USA"
    case egypt = "EGY"
    case kazakhstan = "KAZ"
    case kyrgyzstan = "KGZ"
    case tajikistan = "TJK"
    case turkey = "TUR"
    case uzbekistan = "UZB"
    case other
}

enum PaywallPresentationType {
    case appLaunch, screen(String)
}

protocol SubscriptionManagerType {
    
    /// Whether current user have premium subscription.
    func isProUser() -> Bool
    
    /// Store flag on disk.
    func setProFeaturesActivated(_ flag: Bool)
    
    func getUserRegion() -> UserRegion
    
    func presentPaywall(presentationType: PaywallPresentationType, completion: (() -> Void)?)
    
}
