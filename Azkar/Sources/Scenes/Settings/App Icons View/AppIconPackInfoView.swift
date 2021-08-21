//
//
//  Azkar
//  
//  Created on 13.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI
import Combine

final class AppIconPackInfoViewModel: ObservableObject {

    let pack: AppIconPack

    /// Icon to display.
    let icon: AppIcon

    @Published var processing = false
    @Published var purchased: Bool
    @Published var price: String?

    var closeAction: (() -> Void)?
    var successAction: (() -> Void)?

    private var cancellabels = Set<AnyCancellable>()
    private let service: InAppPurchaseService = .shared

    init(preferences: Preferences, pack: AppIconPack, icon: AppIcon, closeAction: (() -> Void)? = nil, successAction: (() -> Void)? = nil) {
        self.pack = pack
        self.icon = icon
        self.closeAction = closeAction
        self.successAction = successAction

        purchased = preferences.purchasedIconPacks.contains(pack)
    }

    func requestPrice() {
        service
            .requestProductInformation(pack.productIdentifier)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.requestPrice()
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] productInfo in
                self?.price = productInfo.price
            })
            .store(in: &cancellabels)
    }

    func purchase() {
        processing = true
        service
            .purchaseProduct(with: pack.productIdentifier)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] result in
                self?.processing = false
                switch result {
                case .failure:
                    break
                case .finished:
                    self?.purchased = true
                    self?.successAction?()
                }
            }, receiveValue: { [unowned self] _ in
                self.processing = false
            })
            .store(in: &cancellabels)
    }

    func restore() {
        processing = true

        service
            .restorePurchasedProducts()
            .receive(on: RunLoop.main)
            .print("RESTORE")
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] ids in
                self?.processing = false
                guard let id = self?.pack.productIdentifier, ids.contains(id) else {
                    return
                }
                self?.purchased = true
                self?.successAction?()
            })
            .store(in: &cancellabels)
    }

}

struct AppIconPackInfoView: View {

    @ObservedObject var viewModel: AppIconPackInfoViewModel

    private let closeButtonSize: CGFloat = 60
    private var cornerRadius: CGFloat { closeButtonSize * 0.2 }

    var body: some View {
        ZStack(alignment: .top) {
            content
            Image(uiImage: UIImage(named: viewModel.icon.imageName)!)
                .resizable()
                .frame(width: closeButtonSize, height: closeButtonSize)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black.opacity(0.3), lineWidth: 0.3)
                )
                .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0.0, y: 0.3)
                .offset(x: 0, y: -(closeButtonSize * 0.8))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: viewModel.requestPrice)
        }
    }

    var content: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.viewModel.closeAction?()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
            })
            .foregroundColor(Color(.systemGray4))
            .frame(width: 30, height: 30)
            stack
        }
        .padding()
        .background(Color.dimmedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    var stack: some View {
        VStack(alignment: .center, spacing: 16) {

            Color.clear
                .frame(height: 0)

            Text(viewModel.pack.title)
                .font(Font.system(.title2, design: .rounded).smallCaps())
                .kerning(1.5)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text(viewModel.pack.description)
                .kerning(1.5)
                .font(.body)

            if viewModel.processing {
                ActivityIndicator(style: .medium, color: .accent)
                    .frame(height: 40)
            } else {
                if viewModel.purchased {
                    Text("icon_pack.info.purchased-message", comment: "Item purchased label.")
                        .font(Font.system(.body, design: .rounded).smallCaps())
                        .foregroundColor(Color.accent)
                        .frame(height: 60)
                } else if let price = viewModel.price {
                    Button {
                        self.viewModel.purchase()
                    } label: {
                        Text(price)
                            .font(Font.system(.title3, design: .rounded).bold())
                            .foregroundColor(Color.white)
                            .frame(height: 40)
                            .padding(.horizontal, 60)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                } else {
                    ActivityIndicator(style: .medium, color: .accent)
                        .frame(height: 40)
                }
            }

            if !viewModel.purchased {
                Button {
                    viewModel.restore()
                } label: {
                    Text("common.restore", comment: "Restore buton label.")
                        .minimumScaleFactor(0.3)
                        .font(Font.system(.caption, design: .rounded).smallCaps())
                        .frame(height: 20)
                }
                .disabled(viewModel.processing || viewModel.purchased)
            }
        }
    }


}

struct AppIconPackInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AppIconPackInfoViewModel(preferences: Preferences(), pack: .maccinz, icon: AppIcon.gold)
        return AppIconPackInfoView(viewModel: vm)
            .previewDevice("iPhone 12 mini")
            .padding()
            .background(Color.red)
    }
}
