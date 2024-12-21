// Copyright © 2022 Al Jawziyya. All rights reserved. 

import SwiftUI

struct CollapsableSectionHeaderView: View {

    let title: String?
    let isExpanded: Bool
    let isExpandable: Bool
    @Environment(\.colorTheme) var colorTheme

    var body: some View {
        HStack {
            title.flatMap { title in
                Text(title)
                    .systemFont(.caption, modification: .smallCaps)
                    .foregroundStyle(Color.tertiaryText)
            }
            if isExpandable {
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.accent)
                    .rotationEffect(.init(degrees: isExpanded ? 180 : 0))
            }
        }
    }

}
