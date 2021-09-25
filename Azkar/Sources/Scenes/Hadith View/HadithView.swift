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
    var sizeCategory: ContentSizeCategory {
        return viewModel.preferences.sizeCategory
    }

    private let dividerColor = Color.secondaryBackground
    private let dividerHeight: CGFloat = 1

    var body: some View {
        ScrollView {
            self.getContent().padding()
        }
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    private func getContent() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            textView

            viewModel.translation.flatMap { text in
                translationView(text: text)
            }

            VStack(alignment: .leading, spacing: 0) {
                Text("read.narrated-by", comment: "Hadith narrater name label.")
                    .font(Font.system(.caption2, design: .rounded).smallCaps())
                    .foregroundColor(Color.tertiaryText)
                Text(viewModel.source)
                    .font(Font.system(.caption, design: .rounded).weight(.medium).smallCaps())
                    .foregroundColor(.text)
            }
        }
    }

    private func getDivider() -> some View {
        dividerColor.frame(height: dividerHeight)
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
    }

}

struct HadithView_Previews: PreviewProvider {
    static var previews: some View {
        HadithView(viewModel: HadithViewModel(hadith: Hadith.data[0], preferences: Preferences()))
    }
}
