//
//  CheckboxView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct CheckboxView: View {

    @Binding var isCheked: Bool

    var body: some View {
        Image(systemName: isCheked ? "checkmark.circle.fill" : "circle")
            .resizable()
            .scaledToFit()
            .foregroundColor(isCheked ? Color.init(.systemBlue) : Color.gray)
    }

}

struct CheckboxView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CheckboxView(isCheked: .constant(true))
            CheckboxView(isCheked: .constant(false))
        }
        .previewLayout(.fixed(width: 20, height: 20))
    }
}
