// Copyright © 2022 Al Jawziyya. All rights reserved.

import SwiftUI
import AudioPlayer
import Library
import Popovers
import Entities

enum ShareBackgroundTypes: Hashable, Identifiable, CaseIterable {
    static var allCases: [ShareBackgroundTypes] {
        [.any] + ShareBackgroundType.allCases.map { .type($0) }
    }
    
    var id: Self { self }
    
    case any
    case type(ShareBackgroundType)
    
    var title: String {
        switch self {
        case .any: return L10n.Share.BackgroundType.all
        case .type(let type): return type.title
        }
    }
}

struct ZikrShareOptionsView: View {
    
    let zikr: Zikr

    struct ShareOptions {
        enum ShareActionType {
            case sheet, saveImage, copyText
            
            var message: String? {
                switch self {
                case .saveImage:
                    return L10n.Share.imageSaved
                case .copyText:
                    return L10n.Share.textCopied
                case .sheet:
                    return nil
                }
            }
            
            var imageName: String? {
                switch self {
                case .saveImage:
                    return "square.and.arrow.down"
                case .copyText:
                    return "doc.on.doc"
                case .sheet:
                    return nil
                }
            }
        }
        
        let actionType: ShareActionType
        let includeTitle: Bool
        let includeBenefits: Bool
        let includeLogo: Bool
        let includeTranslation: Bool
        let includeOriginalText: Bool
        let includeTransliteration: Bool
        var textAlignment: ZikrShareTextAlignment = .start
        let shareType: ZikrShareType
        var selectedBackground: ZikrShareBackgroundItem
        let enableLineBreaks: Bool
        
        var containsProItem: Bool {
            if shareType == .image {
                includeLogo == false || selectedBackground.isProItem == true
            } else {
                false
            }
        }
    }

    var callback: (ShareOptions) -> Void

    @EnvironmentObject var backgroundsService: ShareBackgroundsServiceType
    @Environment(\.presentationMode) var presentation
    @Environment(\.appTheme) var appTheme
    @Environment(\.colorTheme) var colorTheme
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
    
    @AppStorage("kShareIncludeOriginalText")
    private var includeOriginalText = true
    
    @AppStorage("kShareIncludeTransliteration")
    private var includeTransliteration = true
    
    @AppStorage("kShareShareType")
    private var selectedShareType = ZikrShareType.image

    @AppStorage("kShareTextAlignment")
    private var textAlignment = ZikrShareTextAlignment.start

    @AppStorage("kShareSmartLineBreaks")
    private var enableLineBreaks = true
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State var backgrounds = ZikrShareBackgroundItem.preset
    
    var visibleBackgrounds: [ZikrShareBackgroundItem] {
        switch selectedBackgroundType {
        case .any:
            return backgrounds
        case .type(let shareBackgroundType):
            return backgrounds.filter { $0.type == shareBackgroundType }
        }
    }
    
    @AppStorage("kShareBackground")
    private var selectedBackgroundId: String?

    @State private var selectedBackground: ZikrShareBackgroundItem = .defaultBackground
    
    @State private var shareViewSize: CGSize = .zero
    
    // Add state for scrolling trigger
    @State private var scrollToSelectedBackground = false
    
    // Add states for action tracking
    @State private var processingQuickShareAction: ShareOptions.ShareActionType?
    
    @State private var selectedBackgroundType: ShareBackgroundTypes = .any
    
    @State private var selectedDynamicTypeSize: DynamicTypeSize = .large
    
    private let alignments: [ZikrShareTextAlignment] = [.center, .start]
            
    var body: some View {
        VStack(spacing: 0) {
            toolbar
                .padding()
                    
            scrollView
                .customScrollContentBackground()
        }
        .applyThemedToggleStyle()
        .background(.background, ignoreSafeArea: .all)
        .ignoresSafeArea(edges: selectedShareType == .image ? .bottom : [])
        .task {
            do {
                for try await remoteImageBackgrounds in backgroundsService.loadBackgrounds() {
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
            .disabled(processingQuickShareAction != nil)
            .opacity(processingQuickShareAction != nil ? 0.5 : 1)
            
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
        .animation(.smooth, value: processingQuickShareAction)
    }

    var scrollView: some View {
        ScrollView {
            content
        }
        .showToast(
            message: processingQuickShareAction?.message ?? "",
            icon: processingQuickShareAction?.imageName,
            tint: processingQuickShareAction == .saveImage ? .green : colorTheme.getColor(.accent),
            isPresented: processingQuickShareAction != nil
        )
    }

    var content: some View {
        VStack {
            VStack {
                Color.clear.frame(height: 10)

                shareAsSection

                Divider()

                Toggle(L10n.Share.showExtraOptions, isOn: $showExtraOptions)
                    .padding(.horizontal, 16)

                if showExtraOptions {
                    shareOptions
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                if selectedShareType != .text {
                    Divider()

                    Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo.animation(.smooth))
                        .padding(.horizontal, 16)

                    Divider()
                } else {
                    Color.clear.frame(height: 10)
                }
            }
            .background(.contentBackground)
            .applyTheme()
            .padding()

            if selectedShareType != .text {
                backgroundPickerSection
                    .padding(.vertical)

                shareViewPreviewContainer
            }
        }
        .systemFont(.body)
        .animation(.smooth, value: showExtraOptions)
        .animation(.smooth, value: selectedBackground)
    }

    var shareViewPreviewContainer: some View {
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
                .animation(.smooth, value: selectedBackground.isProItem)
                .animation(.smooth, value: subscriptionManager.isProUser())

            shareViewPreview
                .opacity(0)
                .getViewBoundsGeometry { proxy in
                    shareViewSize = proxy.size
                }
        }
        .transition(.opacity)
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
            includeOriginalText: includeOriginalText,
            includeTranslation: includeTranslation,
            includeTransliteration: includeTransliteration,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            includeSource: false,
            arabicTextAlignment: textAlignment.isCentered ? .center : .trailing,
            otherTextAlignment: textAlignment.isCentered ? .center : .leading,
            nestIntoScrollView: false,
            useFullScreen: false,
            selectedBackground: selectedBackground,
            enableLineBreaks: enableLineBreaks
        )
        .environment(\.dynamicTypeSize, selectedDynamicTypeSize)
        .environment(\.arabicFont, preferences.preferredArabicFont)
        .environment(\.translationFont, preferences.preferredTranslationFont)
        .clipShape(RoundedRectangle(cornerRadius: appTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: appTheme.cornerRadius).stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
        )
        .allowsHitTesting(false)
    }
    
    var backgroundTypePickerMenu: some View {
        Menu {
            ForEach(ShareBackgroundTypes.allCases) { item in
                Button {
                    selectedBackgroundType = item
                } label: {
                    Text(item.title)
                        .systemFont(.callout)
                    if selectedBackgroundType == item {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accent)
                    }
                }
            }
        } label: {
            HStack {
                Text(selectedBackgroundType.title)
                    .foregroundStyle(.secondaryText)
                    .multilineTextAlignment(.trailing)
                Image(systemName: "chevron.down")
                    .foregroundStyle(.secondaryText)
            }
            .systemFont(.caption2, modification: .smallCaps)
        }
    }
    
    var backgroundPickerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(L10n.Share.backgroundHeader)
                        .foregroundStyle(.secondaryText)
                        .systemFont(.subheadline, modification: .smallCaps)

                    Spacer()

                    backgroundTypePickerMenu
                }
                .padding(.horizontal, 16)
                 
                ZikrShareBackgroundPickerView(
                    backgrounds: visibleBackgrounds,
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
            Picker(L10n.Share.shareAs, selection: $selectedShareType.animation(.smooth)) {
                ForEach(ZikrShareType.allCases) { type in
                    Label(type.title, systemImage: type.imageName)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.horizontal, 16)
        }
    }
    
    var shareOptions: some View {
        Section {
            if zikr.title != nil {
                Toggle(L10n.Share.includeTitle, isOn: $includeTitle)
            }
            Toggle(L10n.Share.includeOriginalText, isOn: $includeOriginalText.onChange { newValue in
                if !newValue && !includeTranslation {
                    includeTranslation = true
                }
            })
            if zikr.translation != nil {
                Toggle(L10n.Share.includeTranslation, isOn: $includeTranslation.onChange { newValue in
                    if !newValue && !includeOriginalText {
                        includeOriginalText = true
                    }
                })
            }
            if zikr.transliteration != nil {
                Toggle(L10n.Share.includeTransliteration, isOn: $includeTransliteration)
            }
            if zikr.benefits != nil {
                Toggle(L10n.Share.includeBenefit, isOn: $includeBenefits)
            }
            
            Toggle(L10n.Settings.Breaks.title, isOn: $enableLineBreaks)

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
                
                HStack(spacing: 12) {
                    Text(L10n.Share.fontSize)
                    Spacer()
                    fontSizeButton(false, isDisabled: selectedDynamicTypeSize == DynamicTypeSize.allCases.first)
                    fontSizeButton(true, isDisabled: selectedDynamicTypeSize == DynamicTypeSize.allCases.last)
                }
            }
        }
        .pickerStyle(.segmented)
    }

    @ViewBuilder
    func fontSizeButton(_ increasing: Bool, isDisabled: Bool) -> some View {
        Button(action: {
            let direction = increasing ? 1 : -1
            if let current = DynamicTypeSize.allCases.firstIndex(of: selectedDynamicTypeSize) {
                let newIndex = current + direction
                if newIndex >= 0 && newIndex < DynamicTypeSize.allCases.count {
                    selectedDynamicTypeSize = DynamicTypeSize.allCases[newIndex]
                }
            }
        }) {
            ZStack {
                // Placeholder for sizing.
                Image(systemName: "plus")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .opacity(0)

                Image(systemName: increasing ? "plus" : "minus")
            }
            .font(.title3)
            .foregroundStyle(.white)
            .background(.accent)
            .clipShape(Capsule())
            .grayscale(isDisabled ? 1 : 0)
            .glassEffectCompat(.regular.interactive(), in: Capsule())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    @MainActor
    private func share(actionType: ShareOptions.ShareActionType = .sheet) {
        callback(ShareOptions(
            actionType: actionType,
            includeTitle: includeTitle,
            includeBenefits: includeBenefits,
            includeLogo: includeLogo,
            includeTranslation: includeTranslation,
            includeOriginalText: includeOriginalText,
            includeTransliteration: includeTransliteration,
            textAlignment: textAlignment,
            shareType: selectedShareType,
            selectedBackground: selectedBackground,
            enableLineBreaks: enableLineBreaks
        ))
    }
    
    @MainActor
    private func performAction(actionType: ShareOptions.ShareActionType) async {
        // Perform the share action
        share(actionType: actionType)
        
        guard subscriptionManager.isProUser() || !isProShareOptionsSelected else {
            return
        }
        
        // Show feedback
        withAnimation {
            processingQuickShareAction = actionType
        }
        
        // Wait 3 seconds before enabling the button again
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        
        withAnimation {
            processingQuickShareAction = nil
        }
    }

}

#Preview("Share Options") {
    ZikrShareOptionsView(zikr: .placeholder(), callback: { _ in })
        .tint(Color.accentColor)
        .environmentObject(MockShareBackgroundsService())
}
