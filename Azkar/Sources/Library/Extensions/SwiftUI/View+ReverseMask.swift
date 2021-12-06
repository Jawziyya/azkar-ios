// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

extension View {
    public func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask(
            Rectangle()
                .overlay(
                    mask().blendMode(.destinationOut),
                    alignment: alignment
                )
        )
    }
}
