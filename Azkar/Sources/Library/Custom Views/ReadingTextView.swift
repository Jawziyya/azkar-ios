// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI
import Library

struct ReadingTextView: View {

    let action: (() -> Void)?
    let text: String
    let isArabicText: Bool
    let font: AppFont
    var lineSpacing: CGFloat
    var sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory

    var body: some View {
        Button(
            action: { action?() },
            label: {
                if isArabicText {
                    Text(.init(text))
                        .font(Font.customFont(font, style: .title1, sizeCategory: sizeCategory))
                        .lineSpacing(lineSpacing)
                } else {
                    Text(.init(text))
                        .font(Font.customFont(font, style: .body).leading(.tight))
                        .lineSpacing(lineSpacing)
                }
            }
        )
        .allowsHitTesting(action != nil)
        .multilineTextAlignment(isArabicText ? .trailing : .leading)
        .buttonStyle(.plain)
    }

}
