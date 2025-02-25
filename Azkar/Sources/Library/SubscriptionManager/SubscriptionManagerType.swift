// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine
import StoreKit

enum UserRegion: String, Hashable {
    case russian = "RUS"
    case other
}

protocol SubscriptionManagerType {
    
    /// Whether current user have premium subscription.
    func isProUser() -> Bool
    
    /// Store flag on disk.
    func setProFeaturesActivated(_ flag: Bool)
    
    func getUserRegion() -> UserRegion
    
    func presentPaywall()
    
}
