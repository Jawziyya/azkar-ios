//
//  CircularProgressBar.swift
//  mp3quran
//
//  Created by Abdurahim Jauzee on 30.10.2019.
//  Copyright © 2019 Jawziyya Ltd. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {

    @Binding var value: Double

    var backgroundColor: Color = Color(white: 0.8)
    var tintColor: Color = .accentColor
    var lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(value))
                .stroke(tintColor, lineWidth: lineWidth)
                .rotationEffect(Angle(degrees: -90))
        }
        .padding()
    }

}

struct CircularProgressBar_Preview: PreviewProvider {
    static var previews: some View {
        let value = Binding<Double>.init(get: { () -> Double in
            return 0.5
        }, set: { _ in })
        return CircularProgressBar(value: value)
    }
}
