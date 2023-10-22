// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

struct ScrollContentBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func customScrollContentBackground() -> some View {
        self.modifier(ScrollContentBackgroundModifier())
    }
}
