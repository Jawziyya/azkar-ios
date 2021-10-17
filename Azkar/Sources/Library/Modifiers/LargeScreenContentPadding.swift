// Copyright © 2021 Al Jawziyya. All rights reserved. 

import SwiftUI

struct LargeScreenPadding: ViewModifier {
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    @Environment(\.verticalSizeClass) var vSizeClass
    var defaultPadding: CGFloat?
    
    func body(content: Content) -> some View {
        if hSizeClass == .regular && vSizeClass == .regular {
            content
                .padding(.horizontal, 60)
        } else if let padding = defaultPadding {
            content
                .padding(.horizontal, padding)
        } else {
            content
        }
    }
    
}

extension View {
    
    func largeScreenPadding(defaultPadding: CGFloat? = nil) -> some View {
        modifier(LargeScreenPadding(defaultPadding: defaultPadding))
    }
    
}
