// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

struct CollapsableSectionHeaderView: View {

    let title: String?
    let isExpanded: Bool
    let isExpandable: Bool

    var body: some View {
        HStack {
            title.flatMap { title in
                Text(title)
                    .font(Font.system(.caption, design: .rounded).smallCaps())
                    .foregroundColor(Color.tertiaryText)
            }
            if isExpandable {
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(Color.accent)
                    .rotationEffect(.init(degrees: isExpanded ? 180 : 0))
            }
        }
    }

}
