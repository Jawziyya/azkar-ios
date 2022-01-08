// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine

final class DemoSubscriptionManager: SubscriptionManagerType {

    init(isProUser: Bool = false) {
        self._isProUser = isProUser
    }

    private var _isProUser = false
    private var _isPurchaseSuccessful = true
    
    private let _products = CurrentValueSubject<[Product], Error>([
        Product.placeholder,
        Product.placeholder
    ])
    
    var products: AnyPublisher<[Product], Error> {
        _products.eraseToAnyPublisher()
    }
    
    func loadProducts() {
        _products.send([
            Product.placeholder,
            Product.placeholder
        ])
    }
    
    func isProUser() -> Bool {
        _isProUser
    }
    
    func purchasePackage(with id: String) -> AnyPublisher<PurchaseResult, Error> {
        Just(_isPurchaseSuccessful ? PurchaseResult.purchased : .cancelled)
            .setFailureType(to: Error.self)
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func restorePurchases() -> AnyPublisher<PurchaseResult, Error> {
        Just(_isPurchaseSuccessful ? PurchaseResult.purchased : .cancelled)
            .setFailureType(to: Error.self)
            .delay(for: 2, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func setProFeaturesActivated(_ flag: Bool) {
        _isProUser = flag
    }
    
}
