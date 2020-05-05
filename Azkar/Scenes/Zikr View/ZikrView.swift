//
//  ZikrView.swift
//  Azkar
//
//  Created by Al Jawziyya on 06.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI
import BonMot

struct ZikrView: View {

    var viewModel: ZikrViewModel
    @EnvironmentObject var preferences: Preferences

    @State private var textHeight: CGFloat = 0
    @State private var translationHeight: CGFloat = 0
    @State private var transliterationHeight: CGFloat = 0
    @Environment(\.sizeCategory) var size

    private let tintColor = Color.accent
    private let dividerColor = Color.secondaryBackground.opacity(0.5)
    private let dividerHeight: CGFloat = 1

    var body: some View {
        print(#function, viewModel.title)
        return ScrollView {
            self.getContent()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Title
            HStack {
                Spacer()
                Text(viewModel.title)
                    .font(Font.headline)
                    .foregroundColor(Color.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            }

            // MARK: - Text
            VStack(spacing: 10) {
                CollapsableSection(
                    text: viewModel.zikr.text.styled(with: TextStyles.arabicTextStyle(fontName: self.preferences.arabicFont.fontName, textStyle: .largeTitle, alignment: .center)),
                    isExpanded: .constant(true),
                    textHeight: $textHeight
                )
                .equatable()
                .padding()

                self.playerView
            }

            // MARK: - Translation
            CollapsableSection(title: "перевод", text: viewModel.zikr.translation.styled(with: TextStyles.bodyStyle()), isExpanded: self.$preferences.expandTranslation, textHeight: $translationHeight, tintColor: tintColor) {
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    self.preferences.expandTranslation.toggle()
                }
            }
            .equatable()
            .padding()

            // MARK: -
            getDivider()

            // MARK: - Transliteration
            CollapsableSection(title: "транскрипция", text: viewModel.zikr.transliteration.styled(with: TextStyles.bodyStyle()), isExpanded: self.$preferences.expandTransliteration, textHeight: $transliterationHeight, tintColor: tintColor) {
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    self.preferences.expandTransliteration.toggle()
                }
            }
            .equatable()
            .padding()

            // MARK: -
            getDivider()

            // MARK: - Info
            HStack(alignment: .center, spacing: 20) {
                if viewModel.zikr.repeats > 0 {
                    getInfoStack(label: "повторения", text: String.localizedStringWithFormat(NSLocalizedString("repeats", comment: ""), viewModel.zikr.repeats))
                }

                viewModel.zikr.source.textOrNil.flatMap { text in
                    getInfoStack(label: "источник", text: text)
                }
            }
            .font(.caption)
            .foregroundColor(.text)
            .padding()

            // MARK: - Note
            viewModel.zikr.notes.flatMap { _ in
                self.getDivider()
            }

            viewModel.zikr.notes.flatMap { notes in
                self.getNoteView(notes)
            }

            Spacer(minLength: 20)
        }
    }

    private func getInfoStack(label: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            self.getCaption(label)
            Text(text.firstWord())
                .font(Font.headline.weight(.medium).smallCaps())
        }
    }

    private func getDivider() -> some View {
        dividerColor.frame(height: dividerHeight)
    }

    private func getCaption(_ text: String) -> some View {
        Text(text)
            .font(Font.caption.weight(.thin).smallCaps())
            .foregroundColor(Color.secondaryText)
    }

    private func getNoteView(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(Color.accent)
            Text(text)
                .font(Font.footnote)
        }
        .padding()
    }

    private var playerView: some View {
        PlayerView(
            viewModel: viewModel.playerViewModel,
            tintColor: tintColor,
            progressBarColor: dividerColor,
            progressBarHeight: dividerHeight
        )
    }

}

struct ZikrView_Previews: PreviewProvider {
    static var previews: some View {
        ZikrView(viewModel: ZikrViewModel(zikr: Zikr.data[39], player: .test))
        .environmentObject(Preferences())
        .previewLayout(.fixed(width: 300, height: 500))
    }
}
