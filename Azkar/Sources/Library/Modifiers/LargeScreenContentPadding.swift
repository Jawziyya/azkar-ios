// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

struct LargeScreenPadding: ViewModifier {
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    
    func body(content: Content) -> some View {
        if hSizeClass == .regular && vSizeClass == .regular {
            content
                .padding(.horizontal, 60)
        } else {
            content
        }
    }
    
}

extension View {
    
    func largeScreenPadding() -> some View {
        self.modifier(LargeScreenPadding())
    }
    
}
