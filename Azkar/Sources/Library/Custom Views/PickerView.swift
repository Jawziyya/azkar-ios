// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

struct PickerView<T: View>: View {

    var label: String
    var navigationTitle: String?
    var titleDisplayMode: NavigationBarItem.TitleDisplayMode = .automatic
    var subtitle: String
    var destination: T

    var body: some View {
        NavigationLink(
            destination: destination.navigationBarTitle(navigationTitle ?? label, displayMode: titleDisplayMode)
        ) {
            HStack(spacing: 8) {
                Text(label)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.text)
                Spacer()
                Text(subtitle)
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.secondary)
            }
            .padding(.vertical, 8)
            .buttonStyle(PlainButtonStyle())
        }
    }

}
