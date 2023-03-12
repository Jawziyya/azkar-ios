// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import SwiftUI
import WidgetKit

struct WidgetsEntryView : View {
    var entry: VirtuesProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Text(entry.fadl.text ?? "")
                .font(Font.title3)
                .tracking(1.2)
                .foregroundColor(Color.primary.opacity(0.7))

            Text(entry.fadl.source)
                .font(Font.caption)
                .foregroundColor(Color.secondary.opacity(0.5))
        }
        .shadow(color: Color.primary.opacity(0.5), radius: 0.5, x: 0.0, y: 0.05)
        .multilineTextAlignment(.center)
        .padding()
    }
}
