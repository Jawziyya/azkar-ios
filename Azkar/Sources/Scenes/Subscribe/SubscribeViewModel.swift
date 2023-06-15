// Copyright © 2021 Al Jawziyya. All rights reserved. 

import Foundation
import Combine
import SwiftUI

final class SubscribeViewModel: ObservableObject {
    
    struct SubscriptionOption: Identifiable, Equatable {
        var id: String {
            text + subtitle
        }
        let text: String
        let subtitle: String
        let priceInfo: String
        let productId: String
        var isRenewable = true
        private(set) var isPlaceholder = false
        
        init(product: Product) {
            productId = product.id
            text = product.id
            subtitle = product.billingDescription
            if let period = product.period {
                priceInfo = product.price + "/" + period.type.localizedDescription
            } else {
                priceInfo = product.price
            }
            isRenewable = product.isRenewable
        }
        
        static var placeholder: SubscriptionOption {
            var placeholder = SubscriptionOption(
                product: Product.placeholder
            )
            placeholder.isPlaceholder = true
            return placeholder
        }
    }
    
    @Published var options: [SubscriptionOption] = [
        .placeholder,
        .placeholder
    ]
    @Published var selectedOption: SubscriptionOption? {
        didSet {
            showSubscriptionWarningMessage = selectedOption?.isRenewable == true
        }
    }
    @Published var didLoadData = false
    @Published var showSubscriptionWarningMessage = false
    @Published var isPurchasing = false
    @Published var isPurchased = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let subscriptionManager: SubscriptionManagerType
    
    var purchaseButtonTitle: String {
        if options.count == 1 {
            let price = options[0].priceInfo
            return L10n.Subscribe.purchaseFor(price)
        } else {
            return L10n.Subscribe.purchaseTitle
        }
    }
    
    init(
        subscriptionManager: SubscriptionManagerType = SubscriptionManagerFactory.create()
    ) {
        isPurchased = subscriptionManager.isProUser()
        self.subscriptionManager = subscriptionManager
        subscriptionManager
            .products
            .replaceError(with: [])
            .filter { $0.isEmpty == false }
            .map { products in
                products.map(SubscriptionOption.init)
            }
            .sink(receiveValue: { [unowned self] options in
                didLoadData = true
                self.options = options
            })
            .store(in: &cancellables)
    }
    
    func purchase() {
        if options.count == 1 {
            selectedOption = options.first
        }
        
        guard let option = selectedOption else {
            return
        }
        isPurchasing = true
        
        let process = subscriptionManager
            .purchasePackage(with: option.productId)
        handleProcess(process)
    }
    
    func restorePurchases() {
        isPurchasing = true
        handleProcess(subscriptionManager.restorePurchases())
    }
    
    private func handleProcess(_ process: AnyPublisher<PurchaseResult, Error>) {
        process
            .receive(on: RunLoop.main)
            .sink { [unowned self] completion in
                switch completion {
                    
                case .failure(let error):
                    isPurchasing = false
                    errorMessage = error.localizedDescription
                    
                case .finished:
                    break
                }
            } receiveValue: { [unowned self] result in
                var isPurchased = false
                
                defer {
                    withAnimation(.spring()) {
                        isPurchasing = false
                        guard isPurchased else { return }
                        self.isPurchased = isPurchased
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
                
                switch result {
                    
                case .productNotFound:
                    print("Product not found.")
                    
                case .cancelled:
                    print("Cancelled by the user.")
                    
                case .purchased:
                    isPurchased = true
                    subscriptionManager.setProFeaturesActivated(true)
                    
                }
            }
            .store(in: &cancellables)
    }
    
    static func placeholder(isProUser: Bool = false) -> SubscribeViewModel {
        SubscribeViewModel(subscriptionManager: DemoSubscriptionManager(isProUser: isProUser))
    }
    
}
