// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine
import StoreKit

enum PurchaseResult: Equatable {
    case cancelled, productNotFound, purchased
}

protocol Package {}
struct PlaceholderPackage: Package {}

struct Product {

    struct Period {
        enum PeriodType: Int {
            case unknown = -1
            case day = 0
            case week = 1
            case month = 2
            case year = 3

            var localizedDescription: String {
                NSLocalizedString("subscription.period.\(self)", comment: "")
            }
        }

        let type: PeriodType
        let value: Int
    }

    let id: String
    let price: String
    let period: Period?
    let isRenewable: Bool
    let billingDescription: String
    let package: Package
    
    static var placeholder: Product {
        Product(
            id: UUID().uuidString,
            price: "12.99$",
            period: .init(type: .month, value: 1),
            isRenewable: true,
            billingDescription: "Billed yearly",
            package: PlaceholderPackage()
        )
    }
}

protocol SubscriptionManagerType {
    
    /// All available products.
    var products: AnyPublisher<[Product], Error> { get }
    
    /// Load products information from backend.
    func loadProducts()
    
    /// Whether current user have premium subscription.
    func isProUser() -> Bool
    
    /// Store flag on disk.
    func setProFeaturesActivated(_ flag: Bool)
    
    /// Initiate purchase process.
    func purchasePackage(with id: String) -> AnyPublisher<PurchaseResult, Error>
    
    /// Restore previous purchases.
    func restorePurchases() -> AnyPublisher<PurchaseResult, Error>
    
}
