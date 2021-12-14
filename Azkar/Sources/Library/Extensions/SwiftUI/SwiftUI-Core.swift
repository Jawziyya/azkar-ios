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
    
    func horizontalPaddingForLargeScreen(value: CGFloat = 40, otherDevicesPadding: CGFloat = 0, applyDefaultPadding: Bool = false) -> some View {
        if UIDevice.current.isIpadInterface {
            return self.padding(.horizontal, 40)
        } else if applyDefaultPadding {
            return self.padding(.horizontal)
        } else {
            return self.padding(.horizontal, otherDevicesPadding)
        }
    }
}
