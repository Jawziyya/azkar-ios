// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import RevenueCat
import Combine
import UIKit
import StoreKit
import SuperwallKit

enum AzkarEntitlement: String {
    case pro = "azkar_pro"
    case ultra = "azkar_ultra"
}

enum PurchasingError: LocalizedError {
    case sk2ProductNotFound
    
    var errorDescription: String? {
        switch self {
        case .sk2ProductNotFound:
            return "Superwall didn't pass a StoreKit 2 product to purchase. Are you sure you're not "
            + "configuring Superwall with a SuperwallOption to use StoreKit 1?"
        }
    }
}

final class SubscriptionManager: SubscriptionManagerType {
    
    @Preference(Keys.enableProFeatures, defaultValue: false)
    var enableProFeatures: Bool

    static let shared = SubscriptionManager()
    
    private var subscribedCancellable: AnyCancellable?
        
    private init() {}
    
    func getUserRegion() -> UserRegion {
        if let storeFront = SKPaymentQueue.default().storefront {
            let code = storeFront.countryCode
            return UserRegion(rawValue: code) ?? .other
        } else {
            return .other
        }
    }
    
    func presentPaywall(sourceScreenName: String, completion: (() -> Void)? = nil) {
        let entitlement = getUserRegion() == .russia ? AzkarEntitlement.ultra : AzkarEntitlement.pro
        let presentationHandler = PaywallPresentationHandler()
        presentationHandler.onSkip { reason in
            let event = "paywall_presentation_skip"
            switch reason {
            case .holdout(let experiment):
                AnalyticsReporter.reportEvent(event, metadata: ["source": sourceScreenName, "reason": "holdout", "experiment_id": experiment.id])
            case .noAudienceMatch:
                AnalyticsReporter.reportEvent(event, metadata: ["source": sourceScreenName, "reason": "no_audience_match"])
            case .placementNotFound:
                AnalyticsReporter.reportEvent(event, metadata: ["source": sourceScreenName, "reason": "placement_not_found"])
            }
            completion?()
        }
        presentationHandler.onError { error in
            AnalyticsReporter.reportEvent("paywall_presentation_error", metadata: ["source": sourceScreenName, "error": error.localizedDescription])
            completion?()
        }
        presentationHandler.onPresent { info in
            AnalyticsReporter.reportEvent("paywall_presentation", metadata: ["source": sourceScreenName])
        }
        presentationHandler.onDismiss { info, result in
            let event = "paywall_dismiss"
            switch result {
            case .declined:
                AnalyticsReporter.reportEvent(event, metadata: ["reason": "declined", "source": sourceScreenName])
            case .purchased(let product):
                AnalyticsReporter.reportEvent(event, metadata: ["reason": "purchased", "source": sourceScreenName, "product": product.productIdentifier])
            case .restored:
                AnalyticsReporter.reportEvent(event, metadata: ["reason": "restored", "source": sourceScreenName])
            }
            completion?()
        }
        Superwall.shared.register(placement: entitlement.rawValue, handler: presentationHandler)
    }
    
    func isProUser() -> Bool {
        if UIDevice.current.isMac {
            return true
        } else {
            #if DEBUG
            return CommandLine.arguments.contains("ENABLE_PRO") || enableProFeatures
            #else
            return enableProFeatures
            #endif
        }
    }
    
    func setProFeaturesActivated(_ flag: Bool) {
        enableProFeatures = flag
    }
    
}

extension SubscriptionManager: PurchaseController {
    
    func observerSubsriptionStateWithingSuperwall() {
        subscribedCancellable = Superwall.shared.$subscriptionStatus
          .receive(on: DispatchQueue.main)
          .sink { [weak self] status in
            switch status {
            case .unknown:
                break
            case .active(let entitlements):
                print("Entitlements: \(entitlements)")
                guard entitlements.isEmpty == false else {
                    break
                }
                
                let azkarEntitlements = entitlements.compactMap { entitlement in
                    AzkarEntitlement(rawValue: entitlement.id)
                }
                
                for entitlement in azkarEntitlements {
                    switch entitlement {
                    case .pro:
                        print(entitlement)
                    case .ultra:
                        print(entitlement)
                    }
                    self?.setProFeaturesActivated(true)
                }            
            case .inactive:
                self?.setProFeaturesActivated(false)
            }
          }
    }
    
    // MARK: Sync Subscription Status
    /// Makes sure that Superwall knows the customer's subscription status by
    /// changing `Superwall.shared.subscriptionStatus`
    func syncSubscriptionStatus() {
        assert(Purchases.isConfigured, "You must configure RevenueCat before calling this method.")
        observerSubsriptionStateWithingSuperwall()
        Task {
            if let customerInfo = try? await Purchases.shared.syncPurchases() {
                await handleCustomerInfo(customerInfo)
            }
            for await customerInfo in Purchases.shared.customerInfoStream {
                await handleCustomerInfo(customerInfo)
            }
        }
    }
    
    private func handleCustomerInfo(_ customerInfo: CustomerInfo) async {
        // Gets called whenever new CustomerInfo is available
        let superwallEntitlements = customerInfo.entitlements.activeInCurrentEnvironment.keys.map { id in
            SuperwallKit.Entitlement(id: id)
        }
        await MainActor.run { [superwallEntitlements] in
            if superwallEntitlements.isEmpty {
                Superwall.shared.subscriptionStatus = .inactive
            } else {            
                Superwall.shared.subscriptionStatus = .active(Set(superwallEntitlements))
            }
        }
    }
        
    // MARK: Handle Purchases
    /// Makes a purchase with RevenueCat and returns its result. This gets called when
    /// someone tries to purchase a product on one of your paywalls.
    func purchase(product: SuperwallKit.StoreProduct) async -> SuperwallKit.PurchaseResult {
        do {
            guard let sk2Product = product.sk2Product else {
                AnalyticsReporter.reportEvent("purchase_attempt_error", metadata: ["error": PurchasingError.sk2ProductNotFound.localizedDescription])
                throw PurchasingError.sk2ProductNotFound
            }
            let storeProduct = RevenueCat.StoreProduct(sk2Product: sk2Product)
            let revenueCatResult = try await Purchases.shared.purchase(product: storeProduct)
            if revenueCatResult.userCancelled {
                return .cancelled
            } else {
                return .purchased
            }
        } catch let error as ErrorCode {
            if error == .paymentPendingError {
                AnalyticsReporter.reportEvent("purchase_attempt_payment_pending_error")
                return .pending
            } else {
                AnalyticsReporter.reportEvent("purchase_attempt_error", metadata: ["error": error.localizedDescription])
                return .failed(error)
            }
        } catch {
            AnalyticsReporter.reportEvent("purchase_attempt_error", metadata: ["error": error.localizedDescription])
            return .failed(error)
        }
    }
    
    // MARK: Handle Restores
    /// Makes a restore with RevenueCat and returns `.restored`, unless an error is thrown.
    /// This gets called when someone tries to restore purchases on one of your paywalls.
    func restorePurchases() async -> RestorationResult {
        do {
            _ = try await Purchases.shared.restorePurchases()
            return .restored
        } catch let error {
            return .failed(error)
        }
    }
    
}
