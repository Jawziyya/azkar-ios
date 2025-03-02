// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import AudioPlayer

struct ZikrShareOptionsView: View {
    
    let zikr: Zikr

    struct ShareOptions {
        let includeTitle: Bool
        let includeBenefits: Bool
        let includeLogo: Bool
        var textAlignment: ZikrShareTextAlignment = .start
        let shareType: ZikrShareType
        var selectedBackground: ZikrShareBackgroundItem
        
        var containsProItem: Bool {
            includeLogo == false || selectedBackground.isProItem == true
        }
    }

    var callback: (ShareOptions) -> Void

    @Environment(\.presentationMode) var presentation
    @Environment(\.appTheme) var appTheme
    let subscriptionManager = SubscriptionManager.shared
    
    let preferences = Preferences.shared

    @AppStorage("kShareIncludeTitle")
    private var includeTitle: Bool = true

    @AppStorage("kShareIncludeBenefits")
    private var includeBenefits = true

    @AppStorage("kShareIncludeLogo")
    private var includeLogo = true

    @AppStorage("kShareShareType")
    private var selectedShareType = ZikrShareType.image

    @AppStorage("kShareTextAlignment")
    private var textAlignment = ZikrShareTextAlignment.start
    
    let backgrounds = ZikrShareBackgroundItem.all
    @State private var selectedBackground: ZikrShareBackgroundItem = .defaultBackground

    private let alignments: [ZikrShareTextAlignment] = [.center, .start]
    
    var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding()
            
            content
                .customScrollContentBackground()
        }
        .applyThemedToggleStyle()
        .background(Color.background, ignoresSafeAreaEdges: .all)
    }
    
    var toolbar: some View {
        HStack {
            Button(L10n.Common.done) {
                presentation.dismiss()
            }
            Spacer()
            Button(action: {
                Task {
                    share()
                }
            }, label: {
                if subscriptionManager.isProUser() == false && (selectedBackground.isProItem || includeLogo == false) {
                    Label(L10n.Common.share, systemImage: "lock.fill")
                } else {
                    Text(L10n.Common.share)
                }
            })
            .buttonStyle(.borderedProminent)
            .animation(.smooth, value: includeLogo.hashValue ^ selectedBackground.hashValue)
        }
        .background(Color.background)
    }

    var content: some View {
        ScrollView {
            VStack {
                Color.clear.frame(height: 10)
                
                shareAsSection
                
                shareOptions
                    .padding(.horizontal, 16)
                
                if selectedShareType != .text {
                    Section {
                        Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo.animation(.smooth))
                            .applyThemedToggleStyle(showProBadge: !subscriptionManager.isProUser())
                    }
                    .padding(.horizontal, 16)
                }
                
                if selectedShareType != .text {
                    backgroundPickerSection
                        .padding(.vertical)
                    
                    shareViewPreview
                        .clipShape(RoundedRectangle(cornerRadius: appTheme.cornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: appTheme.cornerRadius).stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                        )
                        .allowsHitTesting(false)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Color.clear.frame(height: 10)
                }
            }
            .systemFont(.body)
            .background(Color.contentBackground)
            .applyTheme()
            .padding()
        }
    }
    
    var shareViewPreview: some View {
        ZikrShareView(
            viewModel: ZikrViewModel(
                zikr: zikr,
                isNested: true,
                hadith: nil,
                preferences: Preferences.shared,
                player: .test
            ),
            includeTitle: includeTitle,
            includeTranslation: preferences.expandTranslation,
            includeTransliteration: preferences.expandTransliteration,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            arabicTextAlignment: textAlignment.isCentered ? .center : .trailing,
            otherTextAlignment: textAlignment.isCentered ? .center : .leading,
            useFullScreen: false,
            selectedBackground: selectedBackground
        )
    }
    
    var backgroundPickerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Background")
                    .foregroundStyle(Color.secondaryText)
                    .systemFont(.subheadline, modification: .smallCaps)
                    .padding(.horizontal, 16)
                
                ZikrSHareBackgroundPickerView(
                    backgrounds: backgrounds,
                    selectedBackground: $selectedBackground
                )
            }
        }
    }
    
    var shareAsSection: some View {
        Section {
            HStack(spacing: 16) {
                Text(L10n.Share.shareAs)
                Spacer()
                Picker(L10n.Share.shareAs, selection: $selectedShareType) {
                    ForEach(ZikrShareType.availableCases) { type in
                        Label(type.title, systemImage: type.imageName)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding(.horizontal, 16)
        }
    }
    
    var shareOptions: some View {
        Section {
            if zikr.title != nil {
                Toggle(L10n.Share.includeTitle, isOn: $includeTitle)
            }
            if zikr.benefits != nil {
                Toggle(L10n.Share.includeBenefit, isOn: $includeBenefits)
            }

            if selectedShareType != .text {
                HStack(spacing: 16) {
                    Text(L10n.Share.textAlignment)
                    Spacer()
                    Picker(L10n.Share.textAlignment, selection: $textAlignment) {
                        ForEach(alignments) { alignment in
                            Image(systemName: alignment.imageName)
                                .tag(alignment)
                        }
                    }
                }
            }
        }
        .pickerStyle(.segmented)
    }

    @MainActor
    private func share() {
        callback(ShareOptions(
            includeTitle: includeTitle,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            textAlignment: textAlignment,
            shareType: selectedShareType,
            selectedBackground: selectedBackground)
        )
    }

}

#Preview("Share Options") {
    ZikrShareOptionsView(zikr: .placeholder(), callback: { _ in })
        .tint(Color.accentColor)
}
