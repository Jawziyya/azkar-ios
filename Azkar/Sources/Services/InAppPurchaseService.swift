//
//
//  Azkar
//  
//  Created on 14.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import Foundation
import Combine
import StoreKit
import SwiftyStoreKit

private func localizedPrice(value: Decimal, locale: Locale) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    formatter.locale = locale
    return formatter.string(for: value) ?? ""
}

struct ProductInfo {
    let title: String
    let description: String
    let price: String
}

final class InAppPurchaseService {

    static let shared = InAppPurchaseService()

    private let preferences = Preferences.shared
    private let storeKitManager = SwiftyStoreKit.self
    private var cachedProducts: [String: ProductInfo] = [:]

    func completeTransactions() {
        storeKitManager.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }

                    // Unlock content
                    let id = purchase.productId
                    guard let iconPack = AppIconPack(rawValue: id) else {
                        continue
                    }
                    self.preferences.purchasedIconPacks.append(iconPack)
                default:
                    break // do nothing
                }
            }
        }
    }

    func requestProductInformation(_ id: String) -> AnyPublisher<ProductInfo, Error> {
        if let product = cachedProducts[id] {
            return Just(product)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Future { promise in
            self.storeKitManager.retrieveProductsInfo(Set(arrayLiteral: id)) { results in
                if let error = results.error {
                    promise(.failure(error))
                } else {
                    let product = results.retrievedProducts.first!
                    let info = ProductInfo(title: product.localizedTitle, description: product.localizedDescription, price: localizedPrice(value: product.price.decimalValue, locale: product.priceLocale))
                    self.cachedProducts[id] = info
                    promise(.success(info))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func purchaseProduct(with id: String) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            self.storeKitManager.purchaseProduct(id) { result in
                switch result {
                case .error(let error):
                    promise(.failure(error))
                case .success(let purchase):
                    switch purchase.transaction.transactionState {
                    case .purchased, .restored:
                        promise(.success(true))
                    default:
                        promise(.success(false))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func restorePurchasedProducts() -> AnyPublisher<[String], Never> {
        return Future { promise in
            self.storeKitManager.restorePurchases(atomically: true) { result in
                let ids = result.restoredPurchases.map(\.productId)
                promise(.success(ids))
            }
        }
        .eraseToAnyPublisher()
    }

}
