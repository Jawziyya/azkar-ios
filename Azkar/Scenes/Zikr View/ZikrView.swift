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

    @ObservedObject var viewModel: ZikrViewModel
    var player: Player
    
//    var preferences: Preferences

    @State private var textHeight: CGFloat = 0
    @State private var translationHeight: CGFloat = 0
    @State private var transliterationHeight: CGFloat = 0
    @Environment(\.sizeCategory) var sizeCategory

    private let tintColor = Color.accent
    private let dividerColor = Color.secondaryBackground
    private let dividerHeight: CGFloat = 1

    var body: some View {
        print(#function, viewModel.title)
        return ScrollView {
            self.getContent()
        }
        .navigationBarTitle(UIDevice.current.isIpad ? viewModel.title : "")
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !UIDevice.current.isIpad {
                titleView
            }
            textView
            translationView

            getDivider()

            transliterationView

            getDivider()

            infoView
            
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

    // MARK: - Title
    private var titleView: some View {
        HStack {
            Spacer()
            Text(viewModel.title)
                .equatable()
                .font(Font.headline)
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
                text: viewModel.zikr.text.styled(with: TextStyles.arabicTextStyle(fontName: self.viewModel.preferences.arabicFont.fontName, textStyle: .title1, alignment: .center, sizeCategory: sizeCategory)),
                isExpanded: .constant(true),
                textHeight: $textHeight
            )
            .equatable()
            .padding([.leading, .trailing, .bottom])

            viewModel.zikr.audioURL.flatMap { url in
                self.playerView(audioURL: url)
            }
        }
    }

    // MARK: - Translation
    private var translationView: some View {
        CollapsableSection(title: "перевод", text: viewModel.zikr.translation.styled(with: TextStyles.bodyStyle(sizeCategory: sizeCategory)), isExpanded: $viewModel.expandTranslation, textHeight: $translationHeight, tintColor: tintColor) {
            withAnimation(Animation.easeInOut(duration: 0.2)) {
                self.viewModel.preferences.expandTranslation.toggle()
            }
        }
        .equatable()
        .padding()
    }

    // MARK: - Transliteration
    private var transliterationView: some View {
        CollapsableSection(title: "транскрипция", text: viewModel.zikr.transliteration.styled(with: TextStyles.bodyStyle(sizeCategory: sizeCategory)), isExpanded: $viewModel.expandTransliteration, textHeight: $transliterationHeight, tintColor: tintColor) {
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
                getInfoStack(label: "повторения", text: String.localizedStringWithFormat(NSLocalizedString("repeats", comment: ""), viewModel.zikr.repeats))
            }

            viewModel.zikr.source.textOrNil.flatMap { text in
                getInfoStack(label: "источник", text: text)
            }
        }
        .font(.caption)
        .padding()
    }

    private func getInfoStack(label: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            self.getCaption(label)
            Text(text.firstWord())
                .font(Font.subheadline.weight(.regular).smallCaps())
                .foregroundColor(.text)
        }
    }

    private func getDivider() -> some View {
        dividerColor.frame(height: dividerHeight)
    }

    private func getCaption(_ text: String) -> some View {
        Text(text)
            .font(Font.caption.weight(.regular).smallCaps())
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
                .font(Font.footnote)
        }
        .padding()
    }

    private func playerView(audioURL: URL) -> some View {
        PlayerView(
            viewModel: PlayerViewModel(title: viewModel.title, subtitle: viewModel.zikr.category.title, audioURL: audioURL, player: player),
            tintColor: tintColor,
            progressBarColor: dividerColor,
            progressBarHeight: dividerHeight
        )
        .equatable()
    }

}

struct ZikrView_Previews: PreviewProvider {
    static var previews: some View {
        ZikrView(viewModel: ZikrViewModel(zikr: Zikr.data[39], preferences: Preferences()), player: .test)
        .environmentObject(Preferences())
        .previewLayout(.fixed(width: 300, height: 500))
    }
}
