//
//
//  Azkar
//  
//  Created on 14.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//
//  Source: https://swiftwithmajid.com/2021/01/27/lazy-navigation-in-swiftui/
//

import SwiftUI

extension NavigationLink where Label == EmptyView {
    init?<Value>(
        _ binding: Binding<Value?>,
        @ViewBuilder destination: (Value) -> Destination
    ) {
        guard let value = binding.wrappedValue else {
            return nil
        }

        let isActive = Binding(
            get: { true },
            set: { newValue in if !newValue { binding.wrappedValue = nil } }
        )

        self.init(destination: destination(value), isActive: isActive, label: EmptyView.init)
    }
}

extension View {
    @ViewBuilder
    func navigate<Value, Destination: View>(
        using binding: Binding<Value?>,
        @ViewBuilder destination: (Value) -> Destination,
        isDetailLink: Bool = false
    ) -> some View {
        background(NavigationLink(binding, destination: destination)?.isDetailLink(UIDevice.current.isIpad || UIDevice.current.isMac ? isDetailLink : true))
    }
}
