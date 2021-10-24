//
//  ZikrView.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct ZikrView: View {

    @ObservedObject var viewModel: ZikrViewModel

    @State private var textHeight: CGFloat = 0
    @State private var translationHeight: CGFloat = 0
    @State private var transliterationHeight: CGFloat = 0
    var sizeCategory: ContentSizeCategory {
        viewModel.preferences.sizeCategory
    }

    private let tintColor = Color.accent
    private let dividerColor = Color.contentBackground
    private let dividerHeight: CGFloat = 1

    var body: some View {
        ScrollView {
            getContent()
                .largeScreenPadding()
        }
        .saturation(viewModel.preferences.colorTheme == .ink ? 0 : 1)
        .background(Color.background.edgesIgnoringSafeArea(.all))
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
                            .font(Font.system(.footnote, design: .rounded))
                    }
                    .padding()
                }
            }

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
                text: viewModel.getText(),
                isExpanded: .constant(true),
                textHeight: $textHeight
            )
            .equatable()
            .padding([.leading, .trailing, .bottom])

            viewModel.playerViewModel.flatMap { vm in
                self.playerView(viewModel: vm)
            }
        }
    }

    // MARK: - Translation
    private func getTranslationView(text: String) -> some View {
        CollapsableSection(title: L10n.Read.translation, text: text.set(style: TextStyles.bodyStyle(sizeCategory: sizeCategory)), isExpanded: $viewModel.expandTranslation, textHeight: $translationHeight, tintColor: tintColor) {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.viewModel.preferences.expandTranslation.toggle()
            }
        }
        .equatable()
        .padding()
    }

    // MARK: - Transliteration
    private func getTransliterationView(text: String) -> some View {
        CollapsableSection(title: L10n.Read.transcription, text: text.set(style: TextStyles.bodyStyle(sizeCategory: sizeCategory)), isExpanded: $viewModel.expandTransliteration, textHeight: $transliterationHeight, tintColor: tintColor) {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.viewModel.preferences.expandTransliteration.toggle()
            }
        }
        .equatable()
        .padding()
    }

    // MARK: - Info
    private var infoView: some View {
        HStack(alignment: .center, spacing: 20) {
            if viewModel.zikr.repeats > 0 {
                getInfoStack(label: L10n.Read.repeats, text: L10n.repeats(viewModel.zikr.repeats))
            }

            viewModel.source.textOrNil.flatMap { text in
                NavigationLink.init(destination: hadithView, label: {
                    getInfoStack(label: L10n.Read.source, text: text, underline: viewModel.hadithViewModel != nil)
                        .hoverEffect(HoverEffect.highlight)
                })
                .disabled(viewModel.hadithViewModel == nil)
            }
        }
        .font(.caption)
        .padding()
    }

    private var hadithView: AnyView {
        if let vm = viewModel.hadithViewModel {
            return LazyView(
                HadithView(viewModel: vm)
            )
            .eraseToAny()
        } else {
            return EmptyView().eraseToAny()
        }
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
                .font(Font.system(.footnote, design: .rounded))
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
        ZikrView(viewModel: ZikrViewModel(zikr: Zikr.data[3], preferences: Preferences(), player: .test))
            .previewDevice("iPad Pro")
            .previewInterfaceOrientation(.portrait)
    }
}
