// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import RevenueCat
import Combine
import UIKit

extension RevenueCat.Package: Package {}

final class SubscriptionManager: SubscriptionManagerType {
    
    @Preference(Keys.enableProFeatures, defaultValue: false)
    var enableProFeatures: Bool

    let _products = CurrentValueSubject<[Product], Error>([])
    
    var products: AnyPublisher<[Product], Error> {
        _products.eraseToAnyPublisher()
    }
    
    static let shared = SubscriptionManager()
    
    private init() {}
    
    func isProUser() -> Bool {
        if UIDevice.current.isMac {
            return true
        } else {
            return enableProFeatures
        }
    }
    
    func loadProducts() {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let currentOffering = offerings?.current else {
                return
            }
            
            func billingDescription(type: PackageType) -> String {
                switch type {
                case .monthly:
                    return L10n.Subscribe.Billing.monthly
                case .lifetime:
                    return L10n.Subscribe.Billing.lifetime
                default:
                    return ""
                }
            }
            
            let products = currentOffering.availablePackages.map { package -> Product in
                var period: Product.Period?
                if let periodInfo = package.storeProduct.subscriptionPeriod {
                    period = Product.Period(
                        type: Product.Period.PeriodType(rawValue: periodInfo.unit.rawValue) ?? .unknown,
                        value: periodInfo.value
                    )
                }

                return Product(
                    id: package.identifier,
                    price: package.localizedPriceString,
                    period: period,
                    isRenewable: package.packageType != .lifetime,
                    billingDescription: billingDescription(type: package.packageType),
                    package: package
                )
            }

            self._products.send(products)
        }
    }
    
    func purchasePackage(with id: String) -> AnyPublisher<PurchaseResult, Error> {
        guard let product = self._products.value.first(where: { $0.id == id }) else {
            return Just(PurchaseResult.productNotFound)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return purchasePackage(product.package)
    }
    
    func purchasePackage(_ package: Package) -> AnyPublisher<PurchaseResult, Error> {
        guard let revenueCatPackage = package as? RevenueCat.Package else {
            return Just(PurchaseResult.productNotFound)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Future { observer in
            Purchases.shared.purchase(package: revenueCatPackage) { _, info, error, cancelled in
                if cancelled {
                    observer(.success(.cancelled))
                    return
                }
                
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                if info?.entitlements["azkar_ultra"]?.isActive == true {
                    observer(.success(.purchased))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func restorePurchases() -> AnyPublisher<PurchaseResult, Error> {
        return Future { observer in
            Purchases.shared
                .restorePurchases { info, error in
                    if let error = error {
                        observer(.failure(error))
                        return
                    }
                    
                    if info?.entitlements["azkar_ultra"]?.isActive == true {
                        observer(.success(.purchased))
                    } else {
                        observer(.success(.cancelled))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    func setProFeaturesActivated(_ flag: Bool) {
        enableProFeatures = flag
    }
    
}
