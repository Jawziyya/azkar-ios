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
    let text: NSAttributedString
    @Binding var isExpanded: Bool
    @Binding var textHeight: CGFloat
    var tintColor: Color = .accent
    var expandingCallback: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: isExpanded ? 10 : 0) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                self.expandingCallback?()
            }, label: {
                HStack {
                    title.flatMap { title in
                        Text(title)
                            .font(Font.caption.weight(.regular).smallCaps())
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
                    GeometryReader { proxy in
                        Label(height: self.$textHeight, containerWidth: proxy.size.width) {
                            return self.text
                        }
                    }
                    .clipped()
                    .transition(.move(edge: .top))
                    .frame(height: self.textHeight)
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
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
