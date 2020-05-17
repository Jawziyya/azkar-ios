//
//  HadithView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 16.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct HadithView: View {

    var viewModel: HadithViewModel

    @State private var textHeight: CGFloat = 0
    @State private var translationHeight: CGFloat = 0
    @Environment(\.sizeCategory) var sizeCategory

    private let dividerColor = Color.secondaryBackground
    private let dividerHeight: CGFloat = 1

    var body: some View {
        ScrollView {
            self.getContent()
        }
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            textView

            viewModel.translation.flatMap { text in
                translationView(text: text)
            }

            VStack(alignment: .leading, spacing: 0) {
                getCaption("привёл")
                Text(viewModel.source)
                    .font(
                        Font.subheadline
                            .weight(.regular)
                            .smallCaps()
                    )
                    .foregroundColor(.text)
            }
            .padding()
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

    // MARK: - Text
    private var textView: some View {
        VStack(spacing: 10) {
            CollapsableSection(
                text: MarkdownProcessor.arabicText(viewModel.text, textStyle: .title1, fontName: viewModel.preferences.arabicFont.fontName, sizeCategory: sizeCategory),
                isExpanded: .constant(true),
                textHeight: $textHeight
            )
            .equatable()
            .padding([.leading, .trailing, .bottom])
        }
    }

    // MARK: - Translation
    private func translationView(text: String) -> some View {
        CollapsableSection(
            title: nil,
            text: MarkdownProcessor.translationText(text, sizeCategory: sizeCategory),
            isExpanded: .constant(true),
            textHeight: $translationHeight
        )
        .padding()
    }

}

struct HadithView_Previews: PreviewProvider {
    static var previews: some View {
        HadithView(viewModel: HadithViewModel(hadith: Hadith.data[0], preferences: Preferences()))
    }
}
