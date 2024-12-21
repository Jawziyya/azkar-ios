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

    var iconsToDisplay: [AppIcon]

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

        var icons = pack.icons
        icons.removeAll(where: { $0.id == icon.id })
        var evenCount = icons.count % 2 == 0 ? icons.count : icons.count - 1
        evenCount = min(4, evenCount)
        iconsToDisplay = Array(icons.shuffled().prefix(evenCount))

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
    @Environment(\.colorTheme) var colorTheme

    private let sampleIconSize: CGFloat = 60
    private var cornerRadius: CGFloat { sampleIconSize * 0.2 }

    @State private var rotate = false

    func getSampleIcon(with name: String) -> some View {
        Image(uiImage: UIImage(named: name)!)
            .resizable()
            .frame(width: sampleIconSize, height: sampleIconSize)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black.opacity(0.3), lineWidth: 0.3)
            )
            .offset(x: 0, y: -(sampleIconSize * 0.8))
    }

    private let rotationAngle: Double = 2.5
    private let yOffset: CGFloat = 2.5
    private var xOffset: CGFloat { sampleIconSize * 0.85 }

    private func offsetForIndex(_ index: Int) -> CGFloat {
        let idx = Int((CGFloat(index) / 2).rounded())
        let offset = xOffset * CGFloat(idx)
        return index % 2 == 0 ? -offset : offset
    }

    private func iconRotationAngle(_ index: Int) -> Double {
        let idx = Int((CGFloat(index) / 2).rounded())
        let offset = rotationAngle * Double(idx)
        return index % 2 == 0 ? offset : -offset
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                self.viewModel.closeAction?()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
            })
            .foregroundStyle(Color(.systemGray4))
            .frame(width: 30, height: 30)
            stack
        }
        .onAppear { viewModel.requestPrice() }
        .padding()
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            AnalyticsReporter.reportScreen("App Icon Pack", className: viewName)
        }
    }

    var stack: some View {
        VStack(alignment: .center, spacing: 16) {

            Color.clear
                .frame(height: 0)

            Text(viewModel.pack.title)
                .font(Font.system(.title2, design: colorTheme.fontDesign).smallCaps())
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
                        .systemFont(.body, modification: .smallCaps)
                        .foregroundStyle(Color.accent)
                        .frame(height: 60)
                } else if let price = viewModel.price {
                    Button {
                        self.viewModel.purchase()
                    } label: {
                        Text(price)
                            .systemFont(.title3, weight: .bold)
                            .foregroundStyle(Color.white)
                            .frame(minHeight: 40, maxHeight: 40)
                            .padding(.horizontal, 60)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                } else {
                    ActivityIndicator(style: .medium, color: .accent)
                        .frame(minHeight: 40, maxHeight: 40)
                }
            }

            if !viewModel.purchased {
                Button {
                    viewModel.restore()
                } label: {
                    Text("common.restore", comment: "Restore buton label.")
                        .minimumScaleFactor(0.3)
                        .systemFont(.caption, modification: .smallCaps)
                        .frame(height: 20)
                }
                .disabled(viewModel.processing || viewModel.purchased)
            }
        }
    }

}

struct AppIconPackInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AppIconPackInfoViewModel(preferences: Preferences.shared, pack: .darsigova, icon: AppIcon.darsigova_1)
        return AppIconPackInfoView(viewModel: vm)
            .previewDevice("iPhone 12 mini")
            .padding()
            .background(Color.red)
    }
}
