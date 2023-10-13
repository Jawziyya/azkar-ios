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
    var lineSpacing: CGFloat
    var sizeCategory: ContentSizeCategory? = Preferences.shared.sizeCategory
    var tintColor: Color = .accent
    var expandingCallback: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded && expandingCallback != nil ? 10 : 0) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                self.expandingCallback?()
            }, label: {
                CollapsableSectionHeaderView(
                    title: title,
                    isExpanded: isExpanded,
                    isExpandable: expandingCallback != nil
                )
            })
            .buttonStyle(BorderlessButtonStyle())
            .zIndex(1)

            ZStack {
                if isExpanded {
                    ReadingTextView(
                        action: nil,
                        text: text,
                        isArabicText: isArabicText,
                        font: font,
                        lineSpacing: lineSpacing,
                        sizeCategory: sizeCategory
                    )
                    .clipped()
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .zIndex(0)
        }
        .clipped()
    }
    
}

struct CollapsableSection_Previews: PreviewProvider {
    static var previews: some View {
        let zikr = Zikr.placeholder
        Stateful(initialState: false) { isExpanded in
            CollapsableSection(
                title: zikr.title ?? "Zikr",
                text: zikr.translation ?? "",
                isArabicText: false,
                isExpanded: isExpanded,
                font: TranslationFont.iowanOldStyle,
                lineSpacing: 10,
                tintColor: Color.blue,
                expandingCallback: {
                    isExpanded.wrappedValue.toggle()
                }
            )
        }
        .previewLayout(.fixed(width: 350, height: 200))
    }
}
