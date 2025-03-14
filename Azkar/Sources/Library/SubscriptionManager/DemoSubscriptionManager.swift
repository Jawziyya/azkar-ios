// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine

final class DemoSubscriptionManager: SubscriptionManagerType {

    init(isProUser: Bool = true) {
        self._isProUser = isProUser
    }

    private var _isProUser: Bool
    private var _isPurchaseSuccessful = true
    
    func getUserRegion() -> UserRegion {
        return .other
    }
    
    func presentPaywall(presentationType: PaywallPresentationType, completion: (() -> Void)?) {
    }
    
    func isProUser() -> Bool {
        _isProUser
    }
    
    func setProFeaturesActivated(_ flag: Bool) {
        _isProUser = flag
    }
    
}
