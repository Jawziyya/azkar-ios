import SwiftUI
import Library
import Fakery

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
