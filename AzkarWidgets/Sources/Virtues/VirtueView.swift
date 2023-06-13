// Copyright © 2023 Al Jawziyya.
// All Rights Reserved.

import SwiftUI
import WidgetKit
import Entities

struct VirtueView : View {
    var fadl: Fadl

    var body: some View {
        VStack(spacing: 8) {
            Text(fadl.text ?? "")
                .font(Font.title3)
                .tracking(1.2)
                .foregroundColor(Color.primary.opacity(0.7))
                .minimumScaleFactor(0.5)

            Text(fadl.source)
                .font(Font.caption)
                .foregroundColor(Color.secondary.opacity(0.5))
        }
        .shadow(
            color: Color.primary.opacity(0.5),
            radius: 0.5,
            x: 0,
            y: 0.05
        )
        .multilineTextAlignment(.center)
        .padding()
    }
}

struct VirtueView_Previews: PreviewProvider {
    
    static var previews: some View {
        VirtueView(fadl: Fadl.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
    
}
