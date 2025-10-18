// Copyright © 2022 Al Jawziyya. All rights reserved.

import SwiftUI
import AudioPlayer
import Library
import Popovers
import Entities
import AzkarResources
import Extensions

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
        let arabicFont: ArabicFont
        let translationFont: TranslationFont
        
        var containsProItem: Bool {
            if shareType == .image {
                let usesArabicFont = includeOriginalText
                let usesTranslationFont = includeTranslation || includeTransliteration || includeBenefits
                return includeLogo == false
                || selectedBackground.isProItem
                || (usesArabicFont && arabicFont.isStandartPackFont != true)
                || (usesTranslationFont && translationFont.isStandartPackFont != true)
            } else {
                return false
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

    @State private var scrollToSelectedBackground = false

    @State private var processingQuickShareAction: ShareOptions.ShareActionType?
    
    @State private var selectedBackgroundType: ShareBackgroundTypes = .any

    @AppStorage("kShareSelectedDynamicTypeSizeIndex")
    private var selectedDynamicTypeSizeIndex: Int = DynamicTypeSize.allCases.firstIndex(of: .large) ?? 0

    @State private var selectedDynamicTypeSize: DynamicTypeSize = .large
    
    private func loadSelectedDynamicTypeSize() {
        let index = max(0, min(selectedDynamicTypeSizeIndex, DynamicTypeSize.allCases.count - 1))
        selectedDynamicTypeSize = DynamicTypeSize.allCases[index]
    }
    
    private func saveSelectedDynamicTypeSize(_ newSize: DynamicTypeSize) {
        if let index = DynamicTypeSize.allCases.firstIndex(of: newSize) {
            selectedDynamicTypeSizeIndex = index
            selectedDynamicTypeSize = newSize
        }
    }
    private let alignments: [ZikrShareTextAlignment] = [.center, .start]
    private let fontsService = FontsService()
    
    @AppStorage("kShareArabicFont")
    private var selectedArabicFontId: String = ""
    
    @AppStorage("kShareTranslationFont")
    private var selectedTranslationFontId: String = ""
    
    @State private var selectedArabicFont: ArabicFont = Preferences.shared.preferredArabicFont
    @State private var selectedTranslationFont: TranslationFont = Preferences.shared.preferredTranslationFont
    
    @State private var appliedArabicFont: ArabicFont = Preferences.shared.preferredArabicFont
    @State private var appliedTranslationFont: TranslationFont = Preferences.shared.preferredTranslationFont
    
    @State private var availableArabicFonts: [ArabicFont] = ZikrShareOptionsView.defaultArabicFonts
    @State private var availableTranslationFonts: [TranslationFont] = ZikrShareOptionsView.defaultTranslationFonts
    
    @State private var fontsLoadingState: FontsLoadingState = .idle
    @State private var downloadingFonts: Set<String> = []
    @State private var fontRefreshToken = UUID()
            
    var body: some View {
        if #available(iOS 26, *) {
            contentWithNavigationToolbar
        } else {
            contentWithCustomToolbar
        }
    }
    
    @available(iOS 26, *)
    private var contentWithNavigationToolbar: some View {
        mainContent
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(L10n.Common.done) {
                        presentation.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbarButtons
                }
            }
    }
    
    private var contentWithCustomToolbar: some View {
        VStack(spacing: 0) {
            toolbar
                .padding()
                    
            mainContent
        }
    }
    
    private var mainContent: some View {
        scrollView
            .customScrollContentBackground()
            .applyThemedToggleStyle()
            .background(.background, ignoreSafeArea: .all)
            .ignoresSafeArea(edges: selectedShareType == .image ? .bottom : [])
            .task {
                if zikr.translation == nil {
                    includeOriginalText = true
                }
                await loadAvailableFontsIfNeeded()
                loadSelectedDynamicTypeSize()
                do {
                    for try await remoteImageBackgrounds in backgroundsService.loadBackgrounds() {
                        backgrounds = ZikrShareBackgroundItem.preset + remoteImageBackgrounds
                        
                        if let selectedBackgroundId = selectedBackgroundId,
                           let foundBackground = backgrounds.first(where: { $0.id == selectedBackgroundId }) {
                            selectedBackground = foundBackground
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            scrollToSelectedBackground = true
                        }
                    }
                } catch {
                    print(error)
                }
            }
    }
    
    private var toolbarButtons: some View {
        HStack(spacing: 16) {
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
                Text(L10n.Common.share)
            })
        }
    }

    private var isUnavailableOptionSelected: Bool {
        isProShareOptionsSelected && !subscriptionManager.isProUser()
    }
    
    private var usesTranslationFont: Bool {
        (includeTranslation && zikr.translation != nil)
        || (includeTransliteration && zikr.transliteration != nil)
        || (includeBenefits && zikr.benefits != nil)
    }
    
    private var isProShareOptionsSelected: Bool {
        guard selectedShareType == .image else { return false }
        return selectedBackground.isProItem
        || !includeLogo
        || (includeOriginalText && isFontPro(selectedArabicFont))
        || (usesTranslationFont && isFontPro(selectedTranslationFont))
    }
    
    var toolbar: some View {
        HStack(spacing: 16) {
            Button(L10n.Common.done) {
                presentation.dismiss()
            }
            Spacer()
            
            toolbarButtons
        }
        .systemFont(.title3)
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

                    HStack {
                        let isLogoOptionLocked = !includeLogo && !subscriptionManager.isProUser()

                        Text(L10n.Share.includeAzkarLogo)
                        Spacer()
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.accent)
                            .scaleEffect(isLogoOptionLocked ? 1 : 0)
                            .opacity(isLogoOptionLocked ? 1 : 0)
                            .animation(.smooth, value: isLogoOptionLocked)
                        Toggle(L10n.Share.includeAzkarLogo, isOn: $includeLogo.animation(.smooth))
                            .labelsHidden()
                    }
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
        .environment(\.arabicFont, appliedArabicFont)
        .environment(\.translationFont, appliedTranslationFont)
        .clipShape(RoundedRectangle(cornerRadius: appTheme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: appTheme.cornerRadius).stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
        )
        .allowsHitTesting(false)
    }
    
    var backgroundTypePicker: some View {
        Picker(selection: $selectedBackgroundType.animation(.smooth)) {
            ForEach(ShareBackgroundTypes.allCases) { item in
                Text(item.title)
                    .tag(item)
            }
        } label: {
            EmptyView()
        }
        .pickerStyle(.segmented)
        .labelsHidden()
    }
    
    var backgroundPickerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.Share.backgroundHeader)
                    .foregroundStyle(.secondaryText)
                    .systemFont(.subheadline, modification: .smallCaps)
                    .padding(.horizontal, 16)

                backgroundTypePicker
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
            if zikr.translation != nil {
                Toggle(L10n.Share.includeOriginalText, isOn: $includeOriginalText.onChange { newValue in
                    if !newValue && !includeTranslation {
                        includeTranslation = true
                    }
                })
            }
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
                Divider()

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

                Divider()

                HStack(spacing: 12) {
                    Text(L10n.Share.fontSize)
                    Spacer()
                    fontSizeButton(false, isDisabled: selectedDynamicTypeSize == DynamicTypeSize.allCases.first)
                    fontSizeButton(true, isDisabled: selectedDynamicTypeSize == DynamicTypeSize.allCases.last)
                }
                
                fontPickers
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
                    saveSelectedDynamicTypeSize(DynamicTypeSize.allCases[newIndex])
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
            enableLineBreaks: enableLineBreaks,
            arabicFont: appliedArabicFont,
            translationFont: appliedTranslationFont
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

    @ViewBuilder
    private var fontPickers: some View {
        Group {
            if includeOriginalText {
                fontMenu(
                    title: L10n.Settings.Text.arabicTextFont,
                    selection: $selectedArabicFont,
                    availableFonts: availableArabicFonts,
                    onSelect: handleArabicFontSelection
                )
            }
            if zikr.translation != nil || zikr.transliteration != nil || zikr.benefits != nil {
                fontMenu(
                    title: L10n.Settings.Text.translationTextFont,
                    selection: $selectedTranslationFont,
                    availableFonts: availableTranslationFonts,
                    onSelect: handleTranslationFontSelection
                )
            }
        }
    }
    
    private func fontMenu<T: AppFont & Identifiable & Hashable>(
        title: String,
        selection: Binding<T>,
        availableFonts: [T],
        onSelect: @escaping (T, T) -> Void
    ) -> some View {
        let proxiedSelection = Binding(
            get: { selection.wrappedValue },
            set: { newValue in
                let previousValue = selection.wrappedValue
                guard !isFontDownloading(newValue) else {
                    return
                }
                selection.wrappedValue = newValue
                onSelect(newValue, previousValue)
            }
        )

        let labelPrefixAccessory: PickerMenuAccessory? = selection.wrappedValue.isStandartPackFont != true && !subscriptionManager.isProUser() ? .image(systemName: "lock.fill", tint: Color.getColor(.accent)) : nil

        return PickerMenu(
            title: title,
            selection: proxiedSelection,
            items: availableFonts,
            itemTitle: { $0.name },
            isItemEnabled: { font in
                return !isFontDownloading(font)
            },
            labelPrefixAccessory: labelPrefixAccessory,
            labelAccessory: isFontDownloading(selection.wrappedValue) ? .progress() : nil
        )
        .disabled(isFontDownloading(selection.wrappedValue))
    }
    
    private func handleArabicFontSelection(_ newFont: ArabicFont, previousFont: ArabicFont) {
        guard newFont != previousFont else { return }
        Task {
            let success = await ensureFontAvailable(newFont)
            await MainActor.run {
                guard selectedArabicFont == newFont else { return }
                if !success {
                    selectedArabicFont = previousFont
                } else {
                    saveArabicFont(newFont)
                }
                normalizeSelectedFonts()
            }
        }
    }
    
    private func handleTranslationFontSelection(_ newFont: TranslationFont, previousFont: TranslationFont) {
        guard newFont != previousFont else { return }
        Task {
            let success = await ensureFontAvailable(newFont)
            await MainActor.run {
                guard selectedTranslationFont == newFont else { return }
                if !success {
                    selectedTranslationFont = previousFont
                } else {
                    saveTranslationFont(newFont)
                }
                normalizeSelectedFonts()
            }
        }
    }
    
    private func needsDownload<T: AppFont>(_ font: T) -> Bool {
        guard fontDownloadURL(for: font) != nil else { return false }
        return !isFontInstalled(font)
    }

    @MainActor
    private func synchronizeAppliedFonts() {
        let resolvedArabic = resolveAppliedFont(
            currentSelection: selectedArabicFont,
            currentApplied: appliedArabicFont,
            availableFonts: availableArabicFonts,
            defaultFont: ZikrShareOptionsView.defaultArabicFonts.first ?? appliedArabicFont
        )
        let resolvedTranslation = resolveAppliedFont(
            currentSelection: selectedTranslationFont,
            currentApplied: appliedTranslationFont,
            availableFonts: availableTranslationFonts,
            defaultFont: ZikrShareOptionsView.defaultTranslationFonts.first ?? appliedTranslationFont
        )
        if resolvedArabic != appliedArabicFont || resolvedTranslation != appliedTranslationFont {
            appliedArabicFont = resolvedArabic
            appliedTranslationFont = resolvedTranslation
        }
    }
    
    private func resolveAppliedFont<T: AppFont & Equatable>(
        currentSelection: T,
        currentApplied: T,
        availableFonts: [T],
        defaultFont: T
    ) -> T {
        if isFontDownloading(currentSelection) {
            return currentApplied
        }
        if !needsDownload(currentSelection) {
            return currentSelection
        }
        if !needsDownload(currentApplied) {
            return currentApplied
        }
        if let installed = availableFonts.first(where: { !needsDownload($0) }) {
            return installed
        }
        return defaultFont
    }
    
    private func mergeFonts<T: Hashable>(
        _ base: [T],
        extras: [T],
        ensuring additional: [T]
    ) -> [T] {
        var seen = Set<T>()
        var result: [T] = []
        
        for font in base {
            if seen.insert(font).inserted {
                result.append(font)
            }
        }
        
        for font in extras {
            if seen.insert(font).inserted {
                result.append(font)
            }
        }
        
        for font in additional {
            if seen.insert(font).inserted {
                result.append(font)
            }
        }
        
        return result
    }
    
    @MainActor
    private func normalizeSelectedFonts() {
        availableArabicFonts = mergeFonts(
            availableArabicFonts,
            extras: [],
            ensuring: [selectedArabicFont]
        )
        
        availableTranslationFonts = mergeFonts(
            availableTranslationFonts,
            extras: [],
            ensuring: [selectedTranslationFont]
        )

        synchronizeAppliedFonts()
    }
    
    private func isFontPro<T: AppFont>(_ font: T) -> Bool {
        font.isStandartPackFont != true
    }
    
    private func isFontLocked<T: AppFont>(_ font: T) -> Bool {
        guard subscriptionManager.isProUser() == false else { return false }
        return isFontPro(font)
    }
    
    private func firstUnlockedFont<T: AppFont & Equatable>(from fonts: [T], excluding target: T? = nil) -> T? {
        fonts.first { font in
            if let target = target, font == target {
                return false
            }
            return !needsDownload(font)
        }
    }
    
    private func isFontDownloading<T: AppFont>(_ font: T) -> Bool {
        downloadingFonts.contains(font.referenceName)
    }
    
    private func isFontInstalled<T: AppFont>(_ font: T) -> Bool {
        guard font.referenceName != STANDARD_FONT_REFERENCE_NAME else {
            return true
        }
        let folderURL = FileManager.default.fontsDirectoryURL.appendingPathComponent(font.referenceName)
        return FileManager.default.fileExists(atPath: folderURL.path)
    }
    
    private func fontDownloadURL<T: AppFont>(for font: T) -> URL? {
        guard font.referenceName != STANDARD_FONT_REFERENCE_NAME else {
            return nil
        }
        return ZikrShareOptionsView.fontDownloadBaseURL
            .appendingPathComponent(font.referenceName)
            .appendingPathComponent("\(font.referenceName).zip")
    }
    
    private func ensureFontAvailable<T: AppFont>(_ font: T) async -> Bool {
        if isFontInstalled(font) {
            return true
        }
        
        guard let downloadURL = fontDownloadURL(for: font) else {
            return true
        }
        
        let downloadKey = font.referenceName
        
        if await MainActor.run(body: { downloadingFonts.contains(downloadKey) }) {
            while await MainActor.run(body: { downloadingFonts.contains(downloadKey) }) {
                try? await Task.sleep(nanoseconds: 200_000_000)
            }
            return isFontInstalled(font)
        }

        downloadingFonts.insert(downloadKey)
        defer {
            Task { @MainActor in
                downloadingFonts.remove(downloadKey)
            }
        }
        
        do {
            let fileURLs = try await fontsService.loadFont(url: downloadURL)
            await MainActor.run {
                FontsHelper.registerFonts(fileURLs)
            }
            return true
        } catch {
            print("Failed to download font \(font.name): \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Font Persistence
    private func loadSavedFonts() {
        if !selectedArabicFontId.isEmpty {
            if let savedFont = availableArabicFonts.first(where: { $0.referenceName == selectedArabicFontId }) {
                selectedArabicFont = savedFont
                appliedArabicFont = savedFont
            }
        }
        
        if !selectedTranslationFontId.isEmpty {
            if let savedFont = availableTranslationFonts.first(where: { $0.referenceName == selectedTranslationFontId }) {
                selectedTranslationFont = savedFont
                appliedTranslationFont = savedFont
            }
        }
    }
    
    private func saveArabicFont(_ font: ArabicFont) {
        selectedArabicFontId = font.referenceName
    }
    
    private func saveTranslationFont(_ font: TranslationFont) {
        selectedTranslationFontId = font.referenceName
    }
    
    @MainActor
    private func loadAvailableFontsIfNeeded() async {
        normalizeSelectedFonts()
        
        guard fontsLoadingState == .idle else {
            normalizeSelectedFonts()
            return
        }
        
        fontsLoadingState = .loading
        
        do {
            async let remoteArabicFonts: [ArabicFont] = fontsService.loadFonts(of: .arabic)
            async let remoteTranslationFonts: [TranslationFont] = fontsService.loadFonts(of: .translation)
            
            let (arabicFonts, translationFonts) = try await (remoteArabicFonts, remoteTranslationFonts)
            
            availableArabicFonts = mergeFonts(
                ZikrShareOptionsView.defaultArabicFonts,
                extras: arabicFonts.sorted { $0.name < $1.name },
                ensuring: [selectedArabicFont]
            )
            
            availableTranslationFonts = mergeFonts(
                ZikrShareOptionsView.defaultTranslationFonts,
                extras: translationFonts.sorted { $0.name < $1.name },
                ensuring: [selectedTranslationFont]
            )
            
            normalizeSelectedFonts()
            loadSavedFonts()
            if needsDownload(selectedArabicFont) {
                let font = selectedArabicFont
                Task {
                    let success = await ensureFontAvailable(font)
                    await MainActor.run {
                        guard selectedArabicFont == font else { return }
                        if !success,
                           let fallback: ArabicFont = firstUnlockedFont(from: availableArabicFonts, excluding: font) {
                            selectedArabicFont = fallback
                        }
                        normalizeSelectedFonts()
                    }
                }
            }
            if needsDownload(selectedTranslationFont) {
                let font = selectedTranslationFont
                Task {
                    let success = await ensureFontAvailable(font)
                    await MainActor.run {
                        guard selectedTranslationFont == font else { return }
                        if !success,
                           let fallback: TranslationFont = firstUnlockedFont(from: availableTranslationFonts, excluding: font) {
                            selectedTranslationFont = fallback
                        }
                        normalizeSelectedFonts()
                    }
                }
            }
            
            fontsLoadingState = .loaded
        } catch {
            fontsLoadingState = .failed
            normalizeSelectedFonts()
        }
    }

    private enum FontsLoadingState {
        case idle, loading, loaded, failed
    }
    
    private static let defaultArabicFonts: [ArabicFont] = ArabicFont.standardFonts.compactMap { $0 as? ArabicFont }
    private static let defaultTranslationFonts: [TranslationFont] = TranslationFont.standardFonts
    private static let fontDownloadBaseURL = URL(string: "https://storage.yandexcloud.net/azkar/fonts/files/")!

}

#Preview("Share Options") {
    ZikrShareOptionsView(zikr: .placeholder(), callback: { _ in })
        .tint(Color.accentColor)
        .environmentObject(MockShareBackgroundsService())
}
