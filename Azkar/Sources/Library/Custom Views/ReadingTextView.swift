// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import Library
import Fakery

func attributedString(_ text: String, highlighting pattern: String? = nil) -> AttributedString {
    var attributedString = (try? AttributedString(markdown: text)) ?? AttributedString(text)
    
    if let pattern = pattern {
        var currentSearchRange = attributedString.startIndex..<attributedString.endIndex
        while let range = attributedString[currentSearchRange].range(of: pattern, options: [.caseInsensitive, .diacriticInsensitive]) {
            let globalRange = range.lowerBound..<range.upperBound
            attributedString[globalRange].backgroundColor = UIColor.systemBlue.withAlphaComponent(0.25)
            
            if globalRange.upperBound < attributedString.endIndex {
                currentSearchRange = globalRange.upperBound..<attributedString.endIndex
            } else {
                break
            }
        }
    }

    return attributedString
}

struct ReadingTextView: View {

    let text: String
    let highlightPattern: String?
    let isArabicText: Bool
    let font: AppFont
    var lineSpacing: CGFloat
    var sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory

    var body: some View {
        Group {
            if isArabicText {
                Text(attributedString(text, highlighting: highlightPattern))
                    .font(Font.customFont(font, style: .title1, sizeCategory: sizeCategory))
                    .lineSpacing(lineSpacing)
            } else {
                Text(attributedString(text, highlighting: highlightPattern))
                    .font(Font.customFont(font, style: .body).leading(.tight))
                    .lineSpacing(lineSpacing)
            }
        }
        .multilineTextAlignment(isArabicText ? .trailing : .leading)
        .buttonStyle(.plain)
    }
    
}

#Preview("Reading Text View") {
    let faker = Faker()
    let words = faker.lorem.paragraphs(amount: 3)
    
    return ReadingTextView(
        text: words,
        highlightPattern: words.components(separatedBy: " ").randomElement(),
        isArabicText: false,
        font: TranslationFont.baskerville,
        lineSpacing: 1,
        sizeCategory: .extraExtraExtraLarge
    )
}
