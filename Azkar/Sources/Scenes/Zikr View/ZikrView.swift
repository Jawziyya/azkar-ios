//
//  ZikrView.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct ZikrView: View {

    @AppStorage("kDidDisplayCounterOnboardingTip", store: UserDefaults.standard)
    var didDisplayCounterOnboardingTip: Bool?

    @ObservedObject var viewModel: ZikrViewModel

    var counterFinishedCallback: Action?

    @State
    private var isLongPressGestureActive = false

    @State
    private var isIncrementActionPerformed = false

    @State
    private var counterFeedbackCompleted = false

    var sizeCategory: ContentSizeCategory {
        viewModel.preferences.sizeCategory
    }

    private let tintColor = Color.accent
    private let dividerColor = Color.accent.opacity(0.1)
    private let dividerHeight: CGFloat = 1

    func incrementZikrCounter() {
        isIncrementActionPerformed = true
        viewModel.incrementZikrCount()
        if viewModel.remainingRepeatsNumber > 0, viewModel.preferences.enableCounterHapticFeedback {
            Haptic.toggleFeedback()
        }
    }

    var body: some View {
        ScrollView {
            getContent()
                .largeScreenPadding()
        }
        .onAppear(perform: viewModel.updateRemainingRepeats)
        .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
        .background(Color.background.edgesIgnoringSafeArea(.all))
        .onKeyboardShortcut("+", modifiers: [.command], perform: viewModel.increaseFontSize)
        .onKeyboardShortcut("-", modifiers: [.command], perform: viewModel.decreaseFontSize)
        .onKeyboardShortcut(.return, modifiers: [.command], perform: viewModel.incrementZikrCount)
        .onTapGesture(count: 2, perform: incrementZikrCounter)
        .onLongPressGesture(
            minimumDuration: 1,
            perform: {
                isLongPressGestureActive = true
                incrementZikrCounter()
            }
        )
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            titleView
            textView
            
            if let text = viewModel.translation {
                getTranslationView(text: text)
                
                getDivider()
            }
            
            if let text = viewModel.transliteration {
                getTransliterationView(text: text)
                
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

                viewModel.zikr.benefit.flatMap { text in
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

            ZStack {
                if viewModel.remainingRepeatsNumber == 0 {
                    LottieView(name: "checkmark", loopMode: .playOnce, contentMode: .scaleAspectFit, speed: 1.5, progress: !isIncrementActionPerformed ? 1 : 0) {
                        self.isLongPressGestureActive = false
                    }
                    .onAppear {
                        if isIncrementActionPerformed, !counterFeedbackCompleted {
                            if viewModel.preferences.enableCounterHapticFeedback {
                                Haptic.successFeedback()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                counterFinishedCallback?()
                                counterFeedbackCompleted.toggle()
                            }
                        }
                    }
                }
            }
            .frame(height: 80, alignment: .center)
            .frame(maxWidth: .infinity)
            .opacity(viewModel.remainingRepeatsNumber == 0 ? 1 : 0)

            Spacer(minLength: 20)
        }
    }

    // MARK: - Title
    private var titleView: some View {
        HStack {
            Spacer()
            Text(viewModel.title)
                .equatable()
                .font(Font.system(.headline, design: .rounded))
                .foregroundColor(Color.secondaryText)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }

    // MARK: - Text
    private var textView: some View {
        VStack(spacing: 10) {
            CollapsableSection(
                text: viewModel.text,
                isArabicText: true,
                isExpanded: .constant(true),
                font: viewModel.preferences.preferredArabicFont
            )
            .id(viewModel.textSettingsToken)
            .padding([.leading, .trailing, .bottom])

            viewModel.playerViewModel.flatMap { vm in
                self.playerView(viewModel: vm)
            }
        }
    }

    // MARK: - Translation
    private func getTranslationView(text: String) -> some View {
        CollapsableSection(
            title: L10n.Read.translation,
            text: text,
            isArabicText: false,
            isExpanded: $viewModel.expandTranslation,
            font: viewModel.preferences.preferredTranslationFont,
            lineHeight: viewModel.preferences.lineHeight,
            tintColor: tintColor
        ) {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.viewModel.preferences.expandTranslation.toggle()
            }
        }
        .id(viewModel.textSettingsToken)
        .padding()
    }

    // MARK: - Transliteration
    private func getTransliterationView(text: String) -> some View {
        CollapsableSection(
            title: L10n.Read.transcription,
            text: text,
            isArabicText: false,
            isExpanded: $viewModel.expandTransliteration,
            font: viewModel.preferences.preferredTranslationFont,
            lineHeight: viewModel.preferences.lineHeight,
            tintColor: tintColor
        ) {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.viewModel.preferences.expandTransliteration.toggle()
            }
        }
        .id(viewModel.textSettingsToken)
        .padding()
    }

    // MARK: - Info
    private var infoView: some View {
        HStack(alignment: .center, spacing: 20) {
            if viewModel.zikr.repeats > 0 {
                getInfoStack(label: L10n.Read.repeats, text: viewModel.remainingRepeatsFormatted)
                    .onTapGesture(perform: viewModel.toggleCounterFormat)
//                    .opacity(viewModel.remainingRepeatsNumber == 0 ? 0.25 : 1)
//                    .overlay {
//                        ZStack {
//                            if viewModel.remainingRepeatsNumber == 0 {
//                                LottieView(name: "checkmark", loopMode: .playOnce, contentMode: .scaleAspectFit, speed: 1, progress: !isIncrementActionPerformed ? 1 : 0) {
//                                    self.isLongPressGestureActive = false
//                                }
//                                .onAppear {
//                                    if isIncrementActionPerformed {
//                                        Haptic.successFeedback()
//                                    }
//                                }
//                            }
//                        }
//                        .frame(width: 60, height: 40)
//                    }
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
            Text(text.firstWord())
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

@available(iOS 15, *)
struct ZikrView_Previews: PreviewProvider {
    static var previews: some View {
        let prefs = Preferences.shared
        prefs.colorTheme = .sea
        return ZikrView(viewModel: ZikrViewModel(zikr: Zikr.data[3], preferences: prefs, player: .test))
            .environment(\.colorScheme, .dark)
    }
}
