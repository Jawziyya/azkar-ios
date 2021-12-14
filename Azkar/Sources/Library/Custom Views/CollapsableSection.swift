//
//  CollapsableSection.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 03.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct CollapsableSection: View, Equatable {

    static func == (lhs: CollapsableSection, rhs: CollapsableSection) -> Bool {
        return lhs.isExpanded == rhs.isExpanded && lhs.text == rhs.text
    }
    
    var title: String?
    let text: String
    let isArabicText: Bool
    @Binding var isExpanded: Bool
    let font: AppFont
    var sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory
    var tintColor: Color = .accent
    var expandingCallback: (() -> Void)?
    
    var lineSpacing: CGFloat {
        CGFloat(25 * (font.lineAdjustment ?? 1))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded && expandingCallback != nil ? 10 : 0) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                self.expandingCallback?()
            }, label: {
                HStack {
                    title.flatMap { title in
                        Text(title)
                            .font(Font.system(.caption, design: .rounded).smallCaps())
                            .foregroundColor(Color.tertiaryText)
                    }
                    if expandingCallback != nil {
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(tintColor)
                            .rotationEffect(.init(degrees: isExpanded ? 180 : 0))
                    }
                }
            })
            .buttonStyle(BorderlessButtonStyle())
            .zIndex(1)

            ZStack {
                if isExpanded {
                    Group {
                        if isArabicText {
                            Text(.init(text))
                                .font(Font.customFont(font, style: .title1, sizeCategory: sizeCategory))
                                .lineSpacing(lineSpacing)
                        } else {
                            Text(.init(text))
                                .font(Font.customFont(font, style: .body))
                                .lineSpacing(lineSpacing)
                        }
                    }
                    .multilineTextAlignment(isArabicText ? .trailing : .leading)
                    .clipped()
                    .transition(.move(edge: .top))
                }
            }
            .zIndex(0)
            .opacity(isExpanded ? 1 : 0)
        }
        .clipped()
    }
    
}

struct CollapsableSection_Previews: PreviewProvider {
    static var previews: some View {
        CollapsableSection(
            title: "Title",
            text: "Text",
            isArabicText: false,
            isExpanded: .constant(true),
            font: TranslationFont.iowanOldStyle,
            tintColor: Color.blue,
            expandingCallback: {}
        )
    }
}
