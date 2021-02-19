//
//
//  Azkar
//  
//  Created on 14.02.2021
//  Copyright © 2021 Al Jawziyya. All rights reserved.
//
//  https://gist.github.com/tiannahenrylewis/a5a3f6abd75b8e864b58ba248e474976

import Foundation
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    typealias UIViewType = UIActivityIndicatorView
    let style: UIActivityIndicatorView.Style
    var color: Color = Color(.systemGray)

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> ActivityIndicator.UIViewType {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = UIColor(self.color)
        return indicator
    }

    func updateUIView(_ uiView: ActivityIndicator.UIViewType, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }

}


struct ActivityIndicatorView<Content> : View where Content : View {

    @Binding var isDisplayed : Bool
    var content: () -> Content

    var body : some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if (!self.isDisplayed) {
                    self.content()
                } else {
                    self.content()
                        .disabled(true)
                        .blur(radius: 3)

                ActivityIndicator(style: .large)
                    .frame(width: geometry.size.width/2.0, height: 200.0)
                    .cornerRadius(20)
                }
            }
        }
    }

}

struct ActivityIndicator_Preview: PreviewProvider {

    static var previews: some View {
        ActivityIndicator(style: .medium, color: .blue)
    }

}
