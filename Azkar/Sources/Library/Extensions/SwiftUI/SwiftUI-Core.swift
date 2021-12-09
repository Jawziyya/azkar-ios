//
//  SwiftUI-Core.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 12.04.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

extension View {
    func embedInNavigation() -> some View {
        NavigationView { self }
    }

    func eraseToAny() -> AnyView {
        return AnyView(self)
    }
    
    func horizontalPaddingForLargeScreen() -> some View {
        self.padding(.horizontal, UIDevice.current.isIpadInterface ? 40 : 0)
    }
}
