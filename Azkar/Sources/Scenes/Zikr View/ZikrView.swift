//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Combine
import SwiftUIDrag
import Extensions
import Library
import Components

/**
 This view shows contents of Zikr object:
    - title
    - text
    - transliteration and translation
    - source
 */
struct ZikrView: View {
    
    @AppStorage("kDidDisplayCounterOnboardingTip", store: UserDefaults.standard)
    var didDisplayCounterOnboardingTip: Bool?

    @ObservedObject var viewModel: ZikrViewModel
    @Environment(\.zikrReadingMode) var zikrReadingMode
    @Environment(\.appTheme) var appTheme

    let incrementAction: AnyPublisher<Void, Never>

    var counterFinishedCallback: Action?

    @State var isIncrementActionPerformed = false
    @State var counterFeedbackCompleted = false
    @Namespace var counterButtonAnimationNamespace
    @State var animateCounterButton = false
    private let counterButtonAnimationId = "counter-button"

    var sizeCategory: ContentSizeCategory {
        viewModel.preferences.sizeCategory
    }

    private let dividerColor = Color.accent.opacity(0.1)
    private let dividerHeight: CGFloat = 1

    func incrementZikrCounter() {
        isIncrementActionPerformed = true
        Task {
            await viewModel.incrementZikrCount()
        }
        if viewModel.remainingRepeatsNumber > 0, viewModel.preferences.enableCounterHapticFeedback {
            HapticGenerator.performFeedback(.impact(flexibility: .soft))
        }
    }
    
    var body: some View {
        if viewModel.isNested {
            scrollView
        } else {
            scrollView
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    var scrollView: some View {
        ScrollView {
            getContent()
        }
        .onAppear {
            AnalyticsReporter.reportScreen("Zikr Reading", className: viewName)
        }
        .environment(\.highlightPattern, viewModel.highlightPattern)
        .onAppear {
            Task {
                await viewModel.updateRemainingRepeats()
            }
        }
        .onDisappear(perform: viewModel.pausePlayer)
        .removeSaturationIfNeeded()
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onReceive(incrementAction, perform: incrementZikrCounter)
        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded { _ in
                    if viewModel.preferences.counterType == .tap {
                        incrementZikrCounter()
                    }
                }
        )
        .overlay(
            counterButton,
            alignment: viewModel.preferences.alignCounterButtonByLeadingSide ? .bottomLeading : .bottomTrailing
        )
    }

    private var counterButton: some View {
        Group {
            Text("1")
                .foregroundStyle(Color.accent)
                .font(Font.system(
                    size: viewModel.preferences.counterSize.value / 3,
                    weight: .regular,
                    design: .monospaced).monospacedDigit()
                )
                .padding()
                .frame(
                    width: viewModel.preferences.counterSize.value,
                    height: viewModel.preferences.counterSize.value
                )
                .foregroundStyle(Color.white)
                .background(Color.accent)
                .clipShape(Capsule())
        }
        .opacity((viewModel.preferences.counterType == .tap) || (!isIncrementActionPerformed || viewModel.remainingRepeatsNumber == 0) ? 0 : 1)
        .matchedGeometryEffect(id: counterButtonAnimationId, in: counterButtonAnimationNamespace)
        .padding(.horizontal)
        .padding(.bottom, Constants.windowSafeAreaInsets.bottom)
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.clear.frame(height: 10)
            
            textContent

            infoView
            
            // MARK: - Notes
            Group {
                viewModel.zikr.notes.flatMap { _ in
                    self.getDivider()
                }

                viewModel.zikr.notes.flatMap { notes in
                    ZikrNoteView(text: notes)
                        .customFont(.body)
                }

                viewModel.zikr.benefits.flatMap { text in
                    ZikrBenefitsView(text: text)
                        .customFont(.footnote)
                }
            }

            Spacer(minLength: 20)

            ZStack(alignment: .center) {
                if viewModel.remainingRepeatsNumber == 0 {
                    LottieView(name: "checkmark", loopMode: .playOnce, contentMode: .scaleAspectFit, speed: 1.5, progress: !isIncrementActionPerformed ? 1 : 0) {
                    }
                    .onAppear {
                        if isIncrementActionPerformed, !counterFeedbackCompleted {
                            if viewModel.preferences.enableCounterHapticFeedback {
                                HapticGenerator.performFeedback(.success)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                counterFinishedCallback?()
                                counterFeedbackCompleted.toggle()
                            }
                        }
                    }
                }
            }
            .background(
                Group {
                    if viewModel.remainingRepeatsNumber == 0 {
                        Circle()
                            .foregroundStyle(Color.clear)
                            .frame(width: 52, height: 52)
                            .matchedGeometryEffect(id: counterButtonAnimationId, in: counterButtonAnimationNamespace)
                    }
                },
                alignment: .center
            )
            .frame(height: 80, alignment: .center)
            .frame(maxWidth: .infinity)
            .opacity(viewModel.remainingRepeatsNumber == 0 || animateCounterButton ? 1 : 0)

            Spacer(minLength: 20)
        }
    }
    
    @ViewBuilder
    private var textContent: some View {
        switch zikrReadingMode {
        case .normal:
            textView
            
            if !viewModel.translation.isEmpty {
                getTranslationView(text: viewModel.translation)
                
                getDivider()
            }
            
            if !viewModel.transliteration.isEmpty {
                getTransliterationView(text: viewModel.transliteration)
                
                getDivider()
            }
            
        case .lineByLine:
            VStack(spacing: 0) {
                ForEach(Array(viewModel.text.enumerated()), id: \.0) { idx, text in
                    let translation = viewModel.translation[safe: idx]
                    let transliteration = viewModel.transliteration[safe: idx]
                    let prefs = viewModel.preferences
                    
                    Button {
                        HapticGenerator.performFeedback(.selection)
                        viewModel.playAudio(at: idx)
                    } label: {
                        VStack {
                            getReadingTextLine(
                                text,
                                isArabicText: true,
                                prefs: prefs,
                                spacing: viewModel.preferences.arabicLineAdjustment,
                                idx: idx,
                                backgroundColor: Color.systemGreen.opacity(0.1)
                            )
                            
                            if let translation, viewModel.expandTranslation {
                                getReadingTextLine(
                                    translation,
                                    isArabicText: false,
                                    prefs: prefs,
                                    spacing: viewModel.preferences.translationLineAdjustment,
                                    idx: idx,
                                    backgroundColor: Color.systemBlue.opacity(0.1)
                                )
                            }
                            
                            if let transliteration, viewModel.expandTransliteration {
                                getReadingTextLine(
                                    transliteration,
                                    isArabicText: false,
                                    prefs: prefs,
                                    spacing: viewModel.preferences.translationLineAdjustment,
                                    idx: idx,
                                    backgroundColor: Color.systemRed.opacity(0.1)
                                )
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .padding()
                    .buttonStyle(.plain)
                    
                    Divider()
                }
                
                viewModel.playerViewModel.flatMap { vm in
                    self.playerView(viewModel: vm)
                        .padding(.vertical)
                }
            }
            
        }
    }

    // MARK: - Title
    private func titleView(_ title: String) -> some View {
        Text(title)
            .equatable()
            .systemFont(.headline)
            .foregroundStyle(Color.secondaryText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }

    @ViewBuilder
    private func getReadingTextView(
        text: [String],
        isArabicText: Bool
    ) -> some View {
        let prefs = viewModel.preferences
        let spacing = isArabicText ? prefs.arabicLineAdjustment : prefs.translationLineAdjustment
        let lines = Array(zip(text.indices, text))
        VStack(spacing: spacing) {
            ForEach(lines, id: \.0) { idx, line in
                let label = getReadingTextLine(
                    line,
                    isArabicText: isArabicText,
                    prefs: prefs,
                    spacing: spacing,
                    idx: idx,
                    backgroundColor: Color.accentColor.opacity(0.15)
                )
                if viewModel.preferences.enableLineBreaks {
                    Button(action: {
                        HapticGenerator.performFeedback(.selection)
                        viewModel.playAudio(at: idx)
                    }, label: {
                        label
                    })
                    .buttonStyle(.plain)
                } else {
                    label
                }
            }
        }
    }
    
    private func getReadingTextLine(
        _ line: String,
        isArabicText: Bool,
        prefs: Preferences,
        spacing: CGFloat,
        idx: Int,
        backgroundColor: Color = Color.clear
    ) -> some View {
        ReadingTextView(
            text: line,
            highlightPattern: viewModel.highlightPattern,
            isArabicText: isArabicText,
            font: isArabicText ? prefs.preferredArabicFont : prefs.preferredTranslationFont,
            lineSpacing: prefs.enableLineBreaks ? spacing : 0
        )
        .background(
            Group {
                if idx == viewModel.indexToHighlight, viewModel.highlightCurrentIndex {
                    backgroundColor
                        .padding(-10)
                        .cornerRadius(6)
                }
            }
        )
        .frame(maxWidth: .infinity, alignment: isArabicText ? .trailing : .leading)
    }

    // MARK: - Text
    private var textView: some View {
        VStack(spacing: 10) {
            getReadingTextView(text: viewModel.text, isArabicText: true)
                .id(viewModel.textSettingsToken)
                .padding([.leading, .trailing, .bottom])

            viewModel.playerViewModel.flatMap { vm in
                self.playerView(viewModel: vm)
            }
        }
    }

    // MARK: - Translation
    private func getTranslationView(text: [String]) -> some View {
        CollapsableView(
            isExpanded: .init(get: {
                viewModel.expandTranslation
            }, set: { newValue in
                withAnimation(Animation.spring()) {
                    viewModel.preferences.expandTranslation = newValue
                }
            }),
            header: {
                CollapsableSectionHeaderView(
                    title: L10n.Read.translation,
                    isExpanded: viewModel.expandTranslation,
                    isExpandable: true
                )
            },
            content: {
                getReadingTextView(text: text, isArabicText: false)
            }
        )
        .id(viewModel.textSettingsToken)
        .padding()
    }

    // MARK: - Transliteration
    private func getTransliterationView(text: [String]) -> some View {
        CollapsableView(
            isExpanded: .init(get: {
                viewModel.expandTransliteration
            }, set: { newValue in
                withAnimation(Animation.spring()) {
                    viewModel.preferences.expandTransliteration = newValue
                }
            }),
            header: {
                CollapsableSectionHeaderView(
                    title: L10n.Read.transcription,
                    isExpanded: viewModel.expandTransliteration,
                    isExpandable: true
                )
            },
            content: {
                getReadingTextView(text: text, isArabicText: false)
            }
        )
        .id(viewModel.textSettingsToken)
        .padding()
    }

    // MARK: - Info
    private var infoView: some View {
        HStack(alignment: .center, spacing: 20) {
            if viewModel.zikr.repeats > 0 {
                getInfoStack(label: L10n.Read.repeats, text: viewModel.remainingRepeatsFormatted)
                    .onTapGesture(perform: viewModel.toggleCounterFormat)
            }

            viewModel.source.textOrNil.flatMap { text in
                NavigationLink(destination: hadithView, label: {
                    getInfoStack(
                        label: L10n.Read.source,
                        text: text,
                        underline: viewModel.hadithViewModel != nil
                    )
                    .hoverEffect(HoverEffect.highlight)
                })
                .disabled(viewModel.hadithViewModel == nil)
            }
        }
        .systemFont(.caption)
        .padding()
    }

    private var hadithView: some View {
        LazyView(
            ZStack {
                if let vm = viewModel.hadithViewModel {
                    HadithView(viewModel: vm)
                }
            }
        )
    }

    private func getInfoStack(label: String, text: String, underline: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            self.getCaption(label)
            Text(getAttributedString(text))
                .if(underline) { text in
                    text.underline()
                }
                .foregroundStyle(Color.text)
                .systemFont(.caption, weight: .medium, modification: .smallCaps)
        }
    }

    private func getDivider() -> some View {
        dividerColor.frame(height: dividerHeight)
    }

    private func getCaption(_ text: String) -> some View {
        Text(getAttributedString(text))
            .systemFont(.caption2, modification: .smallCaps)
            .foregroundStyle(Color.tertiaryText)
    }

    private func getAttributedString(_ text: String) -> AttributedString {
        attributedString(text, highlighting: viewModel.highlightPattern)
    }

    private func playerView(viewModel: PlayerViewModel) -> some View {
        PlayerView(
            viewModel: viewModel,
            tintColor: Color.accent,
            progressBarColor: dividerColor,
            progressBarHeight: dividerHeight
        )
        .equatable()
    }

}

private struct ZikrViewPreview: View {
    var theme: AppTheme
    
    var body: some View {
        let prefs = Preferences.shared
        prefs.appTheme = theme
        return ZikrView(
            viewModel: ZikrViewModel(
                zikr: Zikr.placeholder(),
                isNested: false,
                hadith: Hadith.placeholder,
                preferences: prefs,
                player: .test
            ),
            incrementAction: Empty().eraseToAnyPublisher()
        )
    }
}

#Preview("Default") {
    ZikrViewPreview(theme: .code)
}

#Preview("Sea") {
    ZikrViewPreview(theme: .flat)
        .environment(\.zikrReadingMode, .lineByLine)
}

#Preview("Ink") {
    ZikrViewPreview(theme: .reader)
        .environment(\.zikrReadingMode, .lineByLine)
}
