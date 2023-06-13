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

    private let dividerColor = Color.contentBackground
    private let dividerHeight: CGFloat = 1

    var body: some View {
        ScrollView {
            getContent()
                .largeScreenPadding(defaultPadding: 16)
                .padding(.vertical)
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
        CollapsableSection(
            text: viewModel.text,
            isArabicText: true,
            isExpanded: .constant(true),
            font: viewModel.preferences.preferredArabicFont,
            lineSpacing: viewModel.preferences.arabicLineAdjustment
        )
    }

    // MARK: - Translation
    private func translationView(text: String) -> some View {
        CollapsableSection(
            title: nil,
            text: text,
            isArabicText: false,
            isExpanded: .constant(true),
            font: viewModel.preferences.preferredTranslationFont,
            lineSpacing: viewModel.preferences.translationLineAdjustment
        )
    }

}

struct HadithView_Previews: PreviewProvider {
    static var previews: some View {
        HadithView(viewModel: HadithViewModel(hadith: Hadith.placeholder, preferences: Preferences.shared))
    }
}
