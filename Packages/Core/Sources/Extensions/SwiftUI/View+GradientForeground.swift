// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

extension View {
    public func gradientForeground(colors: [Color], startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> some View {
        self.overlay(
            LinearGradient(
                gradient: .init(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
}
