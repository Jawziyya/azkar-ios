// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

public struct ScrollContentBackgroundModifier: ViewModifier {
    public init() {}
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    public func customScrollContentBackground() -> some View {
        self.modifier(ScrollContentBackgroundModifier())
    }
}
