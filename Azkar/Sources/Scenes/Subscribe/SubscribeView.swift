// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI
import Lottie

struct SubscribeView: View {
    
    @ObservedObject var viewModel: SubscribeViewModel
    @State private var showWhyMessage = false
    
    let closeButtonAction: () -> Void
    
    struct Feature: Equatable, Identifiable {
        var id: String {
            text
        }
        
        let text: String
        let image: String
        let color: SwiftUI.Color
    }
    
    let features: [Feature] = [
        Feature(text: L10n.Subscribe.Features.CustomFonts.title, image: "bold.italic.underline", color: Color.gray),
        Feature(text: L10n.Subscribe.Features.ColorThemes.title, image: "paintpalette", color: Color.purple),
        Feature(text: L10n.Subscribe.Features.ReminderSounds.title, image: "waveform.badge.plus", color: Color.purple),
        Feature(text: L10n.Subscribe.Features.More.title, image: "rectangle.stack.badge.plus", color: Color.blue)
    ]
    
    private let headerHeight: CGFloat = 200
    private let increasedHeaderHeight: CGFloat = 300
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Self._printChanges()
        }
        return subscribeScrollableContent
            .overlay(
                Button(
                    action: closeButtonAction,
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.text)
                            .padding(.vertical)
                            .padding(.horizontal, 16)
                            .opacity(viewModel.isPurchased ? 0 : 1)
                    }
                )
                .buttonStyle(PlainButtonStyle())
                .disabled(viewModel.isPurchasing),
                alignment: .topTrailing
            )
            .overlay(
                VStack(spacing: 8) {
                    purchaseButton
                        .disabled(viewModel.selectedOption == nil)
                        .background(viewModel.isPurchased ? Color.clear : Color.contentBackground)
                        .opacity(viewModel.isPurchasing || viewModel.isPurchased ? 0 : 1)
                        .overlay(
                            ZStack {
                                if viewModel.isPurchasing {
                                    ActivityIndicator(style: .large, color: .secondary)
                                }
                            }
                        )
                    
                    Button(action: viewModel.restorePurchases) {
                        Text(L10n.Subscribe.restore)
                            .foregroundColor(Color.blue)
                            .font(Font.caption)
                            .disabled(viewModel.selectedOption == nil)
                            .opacity(viewModel.isPurchasing || viewModel.isPurchased ? 0 : 1)
                    }
                    .background(Color.contentBackground)
                    .opacity(viewModel.isPurchasing || viewModel.isPurchased ? 0 : 1)
                },
                alignment: .bottom
            )
            .sheet(isPresented: $showWhyMessage) {
                ScrollView {
                    Text(.init(L10n.Subscribe.Why.message))
                        .font(.system(.title3, design: .rounded))
                        .foregroundColor(Color.text)
                        .padding()
                }
            }
    }
    
    var subscribeScrollableContent: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center, spacing: 0) {
                    if viewModel.isPurchased {
                        Spacer()
                    }
                    
                    LottieView(name: "rocket-purple", loopMode: .loop, contentMode: .scaleAspectFit, speed: 1)
                        .cornerRadius(60)
                        .frame(height: viewModel.isPurchased ? increasedHeaderHeight : headerHeight)
                        .frame(maxWidth: .infinity)
                        .offset(y: viewModel.isPurchased ? -50 : 0)
                        .id("rocket-animation")
                    
                    if viewModel.isPurchased {
                        subscribedItems
                    } else {
                        nonSubscribedItems
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity, minHeight: proxy.size.height, maxHeight: .infinity)
            }
            .padding(.horizontal)
            .background(Color.contentBackground.ignoresSafeArea(.all, edges: .all))
            .multilineTextAlignment(.leading)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    var subscribedItems: some View {
        Group {
            Text(.init(L10n.Subscribe.Finish.thanks))
                .font(Font.system(.title, design: .rounded))
                .lineSpacing(1.5)
                .multilineTextAlignment(.center)
                .gradientForeground(colors: [Color.purple, Color.blue], startPoint: .bottomLeading, endPoint: .topTrailing)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            Spacer()
            
            Button(action: closeButtonAction) {
                Text(L10n.Common.done)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .font(.body.bold())
            }
            .cornerRadius(10)
            .padding(.horizontal, 30)
            .buttonStyle(PlainButtonStyle())
            .zIndex(1)
        }
    }
    
    var nonSubscribedItems: some View {
        Group {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Text(.init(L10n.Subscribe.title))
                    + Text(" ") +
                    Text(L10n.Subscribe.Why.title)
                        .foregroundColor(Color.accent)
                        .underline()
                }
                .fixedSize(horizontal: false, vertical: true)
                .onTapGesture {
                    showWhyMessage.toggle()
                }
                    
                ForEach(features) { feature in
                    if #available(iOS 15, *) {
                        featureView(feature)
                            .symbolRenderingMode(.multicolor)
                    } else {
                        featureView(feature)
                    }
                }
            }
            .frame(alignment: .center)
            .padding()
            
            Color.clear.frame(height: 16)
            
            VStack(spacing: 20) {
                ForEach(viewModel.options) { option in
                    planCard(option: option)
                        .redacted(reason: viewModel.didLoadData ? [] : .placeholder)
                        .allowsHitTesting(viewModel.didLoadData && viewModel.selectedOption != option)
                }
            }
            .padding(.horizontal, 30)
            
            Color.clear.frame(height: 20)
                            
            subscriptionInfo
            
            Color.clear.frame(height: 20)
            
            purchaseButton.opacity(0) // Placeholder for spacing
            
            Color.clear.frame(height: 40)
        }
    }
    
    var purchaseButton: some View {
        Button(action: viewModel.purchase) {
            Text(L10n.Subscribe.purchaseTitle)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .font(.body.bold())
        }
        .cornerRadius(10)
        .padding(.horizontal, 30)
        .buttonStyle(PlainButtonStyle())
    }
    
    func featureView(_ feature: Feature) -> some View {
        HStack(spacing: 16) {
            Image(systemName: feature.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(4)
                .foregroundColor(feature.color)
                .cornerRadius(8)
            Text(feature.text)
                .font(Font.system(.body, design: .rounded))
                .foregroundColor(Color.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    func planCard(option: SubscribeViewModel.SubscriptionOption) -> some View {
        Button {
            viewModel.selectedOption = option
            UISelectionFeedbackGenerator().selectionChanged()
        } label: {
            VStack(spacing: 0) {
                Color.clear.frame(height: 0)
                Text(option.priceInfo)
                    .font(Font.system(.title3, design: .rounded).bold())
                    .padding(.horizontal, 30)
                Color.clear.frame(height: 8)
                Text(option.subtitle)
                    .font(Font.system(.caption2, design: .rounded))
                    .padding(.horizontal, 30)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .multilineTextAlignment(.center)
            .padding(12)
            .foregroundColor(Color.text)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 1)
            .overlay(
                Image(systemName: viewModel.selectedOption == option ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(viewModel.selectedOption == option ? Color.accent : Color.gray)
                    .padding(16)
                ,
                alignment: .trailing
            )
            .background(Color.background)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(viewModel.selectedOption == option ? Color.accent : Color.gray, lineWidth: viewModel.selectedOption == option ? 3 : 1)
            )
        }
    }
    
    var subscriptionInfo: some View {
        VStack(spacing: 8) {
            Text("The subscription renews automatically until you turn it off")
            Text("Privacy Policy, Terms & Conditions")
                .underline()
                .foregroundColor(Color.blue)
                .onTapGesture {
                    UIApplication.shared.open(URL(string: "https://raw.githubusercontent.com/Jawziyya/legal-info/master/privacy-policies/azkar-app.txt")!)
                }
        }
        .font(Font.caption2)
        .foregroundColor(Color.tertiaryText)
        .multilineTextAlignment(.center)
    }
    
}

struct SubscribeView_Previews: PreviewProvider {
    static var previews: some View {
        Preferences.shared.colorTheme = .default
        return Group {
            SubscribeView(viewModel: .placeholder, closeButtonAction: {})
                .colorScheme(.light)
            
            SubscribeView(viewModel: .placeholder, closeButtonAction: {})
                .colorScheme(.dark)
        }
    }
}
