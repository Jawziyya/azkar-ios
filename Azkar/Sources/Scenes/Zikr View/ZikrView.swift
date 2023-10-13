//  Copyright © 2020 Al Jawziyya. All rights reserved.

import SwiftUI
import Combine
import SwiftUIDrag
import Extensions
import Library

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

    let incrementAction: AnyPublisher<Void, Never>

    var counterFinishedCallback: Action?

    @State
    private var isLongPressGestureActive = false

    @State
    private var isIncrementActionPerformed = false

    @State
    private var counterFeedbackCompleted = false

    @Namespace
    private var counterButtonAnimationNamespace

    private let counterButtonAnimationId = "counter-button"

    @State private var animateCounterButton = false

    var sizeCategory: ContentSizeCategory {
        viewModel.preferences.sizeCategory
    }

    private let tintColor = Color.accent
    private let dividerColor = Color.accent.opacity(0.1)
    private let dividerHeight: CGFloat = 1

    func incrementZikrCounter() {
        isIncrementActionPerformed = true
        Task {
            await viewModel.incrementZikrCount()
        }
        if viewModel.remainingRepeatsNumber > 0, viewModel.preferences.enableCounterHapticFeedback {
            Haptic.toggleFeedback()
        }
    }

    var body: some View {
        ScrollView {
            getContent()
                .largeScreenPadding()
        }
        .onAppear {
            Task {
                await viewModel.updateRemainingRepeats()
            }
        }
        .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onKeyboardShortcut("+", modifiers: [.command], perform: viewModel.increaseFontSize)
        .onKeyboardShortcut("-", modifiers: [.command], perform: viewModel.decreaseFontSize)
        .onKeyboardShortcut(.return, modifiers: [.command], perform: {
            Task {
                await viewModel.incrementZikrCount()
            }
        })
        .onReceive(incrementAction, perform: incrementZikrCounter)
        .onTapGesture(count: 2, perform: {
            guard viewModel.preferences.counterType == .tap else {
                return
            }
            incrementZikrCounter()
        })
        .onLongPressGesture(
            minimumDuration: 1,
            perform: {
                guard viewModel.preferences.counterType == .tap else {
                    return
                }
                isLongPressGestureActive = true
                incrementZikrCounter()
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
                .foregroundColor(Color.accent)
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
                .foregroundColor(Color.white)
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
            titleView(viewModel.title)
            textView
            
            if !viewModel.translation.isEmpty {
                getTranslationView(text: viewModel.translation)
                
                getDivider()
            }
            
            if !viewModel.transliteration.isEmpty {
                getTransliterationView(text: viewModel.transliteration)
                
                getDivider()
            }

            infoView
            
            // MARK: - Notes
            Group {
                viewModel.zikr.notes.flatMap { _ in
                    self.getDivider()
                }

                viewModel.zikr.notes.flatMap { notes in
                    self.getNoteView(notes)
                }

                viewModel.zikr.benefits.flatMap { text in
                    HStack(alignment: .top, spacing: 8) {
                        Text("💎")
                            .minimumScaleFactor(0.1)
                            .font(Font.largeTitle)
                            .frame(maxWidth: 20, maxHeight: 15)
                            .foregroundColor(Color.accent)
                        Text(text)
                            .font(.customFont(viewModel.preferences.preferredTranslationFont, style: .footnote))
                    }
                    .padding()
                }
            }

            Spacer(minLength: 20)

            ZStack(alignment: .center) {
                if viewModel.remainingRepeatsNumber == 0 {
                    LottieView(name: "checkmark", loopMode: .playOnce, contentMode: .scaleAspectFit, speed: 1.5, progress: !isIncrementActionPerformed ? 1 : 0) {
                        self.isLongPressGestureActive = false
                    }
                    .onAppear {
                        if isIncrementActionPerformed, !counterFeedbackCompleted {
                            if viewModel.preferences.enableCounterHapticFeedback {
                                Haptic.successFeedback()
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
                            .foregroundColor(Color.clear)
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

    // MARK: - Title
    private func titleView(_ title: String) -> some View {
        HStack {
            Spacer()
            Text(title)
                .equatable()
                .font(Font.system(.headline, design: .rounded))
                .foregroundColor(Color.secondaryText)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }

    private func getReadingTextView(
        text: [String],
        isArabicText: Bool,
        font: AppFont,
        spacing: CGFloat,
        lineSpacing: CGFloat,
        alignment: Alignment
    ) -> some View {
        VStack(spacing: spacing) {
            ForEach(Array(zip(text.indices, text)), id: \.0) { idx, line in
                ReadingTextView(
                    action: !viewModel.preferences.enableLineBreaks ? nil : {
                        viewModel.playAudio(at: idx)
                    },
                    text: line,
                    isArabicText: isArabicText,
                    font: font,
                    lineSpacing: lineSpacing
                )
                .background(
                    Group {
                        if idx == viewModel.indexToHighlight, viewModel.highlightCurrentIndex {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color.accent)
                                .opacity(0.15)
                                .padding(isArabicText ? -4 : 0)
                        }
                    }
                )
                .frame(maxWidth: .infinity, alignment: alignment)
            }
        }
    }

    // MARK: - Text
    private var textView: some View {
        VStack(spacing: 10) {
            getReadingTextView(
                text: viewModel.text,
                isArabicText: true,
                font: viewModel.preferences.preferredArabicFont,
                spacing: viewModel.preferences.arabicLineAdjustment,
                lineSpacing: viewModel.preferences.enableLineBreaks ? 0 : viewModel.preferences.arabicLineAdjustment,
                alignment: .trailing
            )
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
                getReadingTextView(
                    text: text,
                    isArabicText: false,
                    font: viewModel.preferences.preferredTranslationFont,
                    spacing: viewModel.preferences.translationLineAdjustment,
                    lineSpacing: viewModel.preferences.enableLineBreaks ? 0 : viewModel.preferences.translationLineAdjustment,
                    alignment: .leading
                )
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
                getReadingTextView(
                    text: text,
                    isArabicText: false,
                    font: viewModel.preferences.preferredTranslationFont,
                    spacing: viewModel.preferences.translationLineAdjustment,
                    lineSpacing: viewModel.preferences.enableLineBreaks ? 0 : viewModel.preferences.translationLineAdjustment,
                    alignment: .leading
                )
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
        .font(.caption)
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
            Text(text)
                .if(underline, transform: { text in
                    text.underline()
                })
                .foregroundColor(.text)
                .font(Font.system(.caption, design: .rounded).weight(.medium).smallCaps())
        }
    }

    private func getDivider() -> some View {
        dividerColor.frame(height: dividerHeight)
    }

    private func getCaption(_ text: String) -> some View {
        Text(text)
            .font(Font.system(.caption2, design: .rounded).smallCaps())
            .foregroundColor(Color.tertiaryText)
    }

    private func getNoteView(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(Color.accent)
            Text(text)
                .font(Font.customFont(viewModel.preferences.preferredTranslationFont, style: .footnote))
        }
        .padding()
    }

    private func playerView(viewModel: PlayerViewModel) -> some View {
        PlayerView(
            viewModel: viewModel,
            tintColor: tintColor,
            progressBarColor: dividerColor,
            progressBarHeight: dividerHeight
        )
        .equatable()
    }

}

struct ZikrView_Previews: PreviewProvider {
    static var previews: some View {
        let prefs = Preferences.shared
        prefs.colorTheme = .sea
        return ZikrView(
            viewModel: ZikrViewModel(
                zikr: Zikr.placeholder,
                hadith: Hadith.placeholder,
                preferences: prefs,
                player: .test
            ),
            incrementAction: Empty().eraseToAnyPublisher()
        )
        .environment(\.colorScheme, .dark)
    }
}
