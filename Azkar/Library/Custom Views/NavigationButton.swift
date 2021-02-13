//
//
//  Azkar
//  
//  Created on 13.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//  

import SwiftUI

struct NavigationButton<Destination: View, Label: View>: View {
    var isDetail = false
    var action: () -> Void = { }
    var destination: () -> Destination
    var label: () -> Label

    @State private var isActive: Bool = false

    var body: some View {
        Button(action: {
            self.action()
            self.isActive.toggle()
        }) {
            self.label()
              .background(NavigationLink(destination: self.destination(), isActive: self.$isActive) {
                  EmptyView()
              }.isDetailLink(isDetail))
        }
    }
}
