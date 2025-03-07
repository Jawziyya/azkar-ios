// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import AudioPlayer
import Library
import Popovers

struct ZikrShareOptionsView: View {
    
    let zikr: Zikr

    struct ShareOptions {
        enum ShareActionType {
            case sheet, saveImage, copyText
        }
        
        let actionType: ShareActionType
        let includeTitle: Bool
        let includeBenefits: Bool
        let includeLogo: Bool
        let includeTranslation: Bool
        let includeTransliteration: Bool
        var textAlignment: ZikrShareTextAlignment = .start
        let shareType: ZikrShareType
        var selectedBackground: ZikrShareBackgroundItem
        
        var containsProItem: Bool {
            includeLogo == false || selectedBackground.isProItem == true
        }
    }

    var callback: (ShareOptions) -> Void

    @EnvironmentObject var backgroundsService: ShareBackgroundService
    @Environment(\.presentationMode) var presentation
    @Environment(\.appTheme) var appTheme
    let subscriptionManager = SubscriptionManager.shared
    
    let preferences = Preferences.shared
    
    @AppStorage("kShareShowExtraOptions")
    private var showExtraOptions = false

    @AppStorage("kShareIncludeTitle")
    private var includeTitle: Bool = true

    @AppStorage("kShareIncludeBenefits")
    private var includeBenefits = true

    @AppStorage("kShareIncludeLogo")
    private var includeLogo = true
    
    @AppStorage("kShareIncludeTranslation")
    private var includeTranslation = true
    
    @AppStorage("kShareIncludeTransliteration")
    private var includeTransliteration = true
    
    @AppStorage("kShareShareType")
    private var selectedShareType = ZikrShareType.image

    @AppStorage("kShareTextAlignment")
    private var textAlignment = ZikrShareTextAlignment.start
    
    @State var backgrounds = ZikrShareBackgroundItem.preset
    
    @AppStorage("kShareBackground")
    private var selectedBackgroundId: String?

    @State private var selectedBackground: ZikrShareBackgroundItem = .defaultBackground
    
    @State private var shareViewSize: CGSize = .zero
    
    // Add state for scrolling trigger
    @State private var scrollToSelectedBackground = false
    
    // Add states for action tracking
    @State private var isPerformingAction = false
    @State private var showCopyFeedback = false
    @State private var copyFeedbackMessage = ""
    @State private var copyFeedbackIcon = ""
    
    private let alignments: [ZikrShareTextAlignment] = [.center, .start]
            
    var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding()
                    
            content
                .customScrollContentBackground()
        }
        .applyThemedToggleStyle()
        .background(.background, ignoreSafeArea: .all)
        .task {
            do {
                let remoteImageBackgrounds = try await backgroundsService.loadBackgrounds()
                backgrounds = ZikrShareBackgroundItem.preset + remoteImageBackgrounds
                
                // Set selectedBackground based on selectedBackgroundId after backgrounds are loaded
                if let selectedBackgroundId = selectedBackgroundId,
                   let foundBackground = backgrounds.first(where: { $0.id == selectedBackgroundId }) {
                    selectedBackground = foundBackground
                }
                
                // Trigger scroll to selected background after backgrounds are loaded
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    scrollToSelectedBackground = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    private var isProShareOptionsSelected: Bool {
        guard selectedShareType == .image else { return false }
        return selectedBackground.isProItem || !includeLogo
    }
    
    var toolbar: some View {
        HStack(spacing: 16) {
            Button(L10n.Common.done) {
                presentation.dismiss()
            }
            Spacer()
            
            Button(action: {
                Task {
                    await performAction(actionType: selectedShareType == .image ? .saveImage : .copyText)
                }
            }, label: {
                Image(systemName: selectedShareType == .image ? "square.and.arrow.down" : "doc.on.doc")
            })
            .disabled(isPerformingAction)
            .opacity(isPerformingAction ? 0.6 : 1)
            
            Button(action: {
                Task {
                    share(actionType: .sheet)
                }
            }, label: {
                if subscriptionManager.isProUser() == false && isProShareOptionsSelected {
                    Label(L10n.Common.share, systemImage: "lock.fill")
                } else {
                    Text(L10n.Common.share)
                }
            })
            .buttonStyle(.borderedProminent)
        }
        .systemFont(.title3)
        .background(.background)
        .animation(.smooth, value: includeLogo.hashValue ^ selectedBackground.hashValue)
        .animation(.smooth, value: isPerformingAction)
    }

    var content: some View {
        ScrollView {
            VStack {
                Color.clear.frame(height: 10)
                
                shareAsSection
                
                Divider()
                
                Toggle(L10n.Share.showExtraOptions, isOn: $showExtraOptions)
                    .padding(.horizontal, 16)
                
                if showExtraOptions {
                    shareOptions
                        .padding(.horizontal, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                if selectedShareType != .text {
                    Divider()
                    
                    Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo.animation(.smooth))
                        .applyThemedToggleStyle(showProBadge: !subscriptionManager.isProUser())
                        .padding(.horizontal, 16)
                    
                    Divider()
                    
                    backgroundPickerSection
                        .padding(.vertical)
                    
                    ZStack {
                        shareViewPreview
                            .frame(width: shareViewSize.width, height: shareViewSize.height)
                            .screenshotProtected(isProtected: selectedBackground.isProItem && !subscriptionManager.isProUser())
                            .background {
                                if selectedBackground.isProItem && !subscriptionManager.isProUser() {
                                    VStack(alignment: .center) {
                                        Spacer()
                                        Image(systemName: "lock.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .foregroundStyle(.accent)
                                        Spacer()
                                    }
                                }
                            }
                        
                        shareViewPreview
                            .opacity(0)
                            .getViewBoundsGeometry { proxy in
                                shareViewSize = proxy.size
                            }
                    }
                } else {
                    Color.clear.frame(height: 10)
                }
            }
            .systemFont(.body)
            .background(.contentBackground)
            .applyTheme()
            .animation(.smooth, value: showExtraOptions)
            .padding()
        }
        .showToast(
            message: copyFeedbackMessage, 
            icon: copyFeedbackIcon, 
            tint: copyFeedbackIcon.contains("checkmark") ? .green : .accentColor,
            isPresented: showCopyFeedback
        )
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
            includeTranslation: includeTranslation,
            includeTransliteration: includeTransliteration,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            includeSource: false,
            arabicTextAlignment: textAlignment.isCentered ? .center : .trailing,
            otherTextAlignment: textAlignment.isCentered ? .center : .leading,
            nestIntoScrollView: false,
            useFullScreen: false,
            selectedBackground: selectedBackground
        )
        .environment(\.arabicFont, preferences.preferredArabicFont)
        .environment(\.translationFont, preferences.preferredTranslationFont)
        .clipShape(RoundedRectangle(cornerRadius: appTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: appTheme.cornerRadius).stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
        )
        .allowsHitTesting(false)
    }
    
    var backgroundPickerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.Share.backgroundHeader)
                    .foregroundStyle(.secondaryText)
                    .systemFont(.subheadline, modification: .smallCaps)
                    .padding(.horizontal, 16)
                
                ZikrShareBackgroundPickerView(
                    backgrounds: backgrounds,
                    selectedBackground: Binding(
                        get: { self.selectedBackground },
                        set: { newValue in 
                            self.selectedBackground = newValue
                            if !newValue.isProItem || subscriptionManager.isProUser() {
                                self.selectedBackgroundId = newValue.id
                            }
                        }
                    ),
                    scrollToSelection: $scrollToSelectedBackground
                )
                .frame(height: 80)
            }
        }
    }
    
    var shareAsSection: some View {
        Section {
            HStack(spacing: 16) {
                Text(L10n.Share.shareAs)
                Spacer()
                Picker(L10n.Share.shareAs, selection: $selectedShareType.animation(.smooth)) {
                    ForEach(ZikrShareType.allCases) { type in
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
            if zikr.translation != nil {
                Toggle(L10n.Share.includeTranslation, isOn: $includeTranslation)
            }
            if zikr.transliteration != nil {
                Toggle(L10n.Share.includeTransliteration, isOn: $includeTransliteration)
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
    private func share(actionType: ShareOptions.ShareActionType = .sheet) {
        callback(ShareOptions(
            actionType: actionType,
            includeTitle: includeTitle,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            includeTranslation: includeTranslation,
            includeTransliteration: includeTransliteration,
            textAlignment: textAlignment,
            shareType: selectedShareType,
            selectedBackground: selectedBackground)
        )
    }
    
    @MainActor
    private func performAction(actionType: ShareOptions.ShareActionType) async {
        // Set state to indicate action is in progress
        isPerformingAction = true
        
        // Perform the share action
        share(actionType: actionType)
        
        // Configure feedback based on action type
        if actionType == .copyText {
            copyFeedbackMessage = L10n.Share.textCopied
            copyFeedbackIcon = "doc.on.doc.fill"
        } else if actionType == .saveImage {
            copyFeedbackMessage = L10n.Share.imageSaved
            copyFeedbackIcon = "checkmark.circle.fill"
        }
        
        // Show feedback
        withAnimation {
            showCopyFeedback = true
        }
        
        // Wait 3 seconds before enabling the button again
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        withAnimation {
            isPerformingAction = false
            showCopyFeedback = false
        }
    }

}

#Preview("Share Options") {
    ZikrShareOptionsView(zikr: .placeholder(), callback: { _ in })
        .tint(Color.accentColor)
}
