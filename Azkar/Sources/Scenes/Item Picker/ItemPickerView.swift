//
//  ItemPickerView.swift
//  Azkar
//
//  Created by Abdurahim Jauzee on 04.05.2020.
//  Copyright © 2020 Al Jawziyya. All rights reserved.
//

import SwiftUI

struct ItemPickerView<SelectionValue>: View where SelectionValue: Hashable & PickableItem {

    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: SelectionValue
    var header: String?
    let items: [SelectionValue]
    var footer: String?
    var dismissOnSelect = false
    var enableHapticFeedback = true

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                if let header = header {
                    Text(header)
                        .font(Font.callout.smallCaps())
                        .foregroundColor(Color.text)
                }
                
                VStack {
                    content
                        .padding(16)
                }
                .background(Color.contentBackground)
                .cornerRadius(10)
                
                if let footer = footer {
                    Text(footer)
                        .font(.caption)
                        .foregroundColor(Color.secondaryText)
                }
            }
            .padding()
        }
        .environment(\.horizontalSizeClass, .regular)
        .horizontalPaddingForLargeScreen()
        .background(Color.background.edgesIgnoringSafeArea(.all))
    }

    var content: some View {
        ForEach(items, id: \.title) { item in
            Button {
                DispatchQueue.main.async {
                    if item != self.selection {
                        self.selection = item
                    }
                    UISelectionFeedbackGenerator().selectionChanged()
                    if self.dismissOnSelect {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            } label: {
                HStack(spacing: 16) {
                    item.image.flatMap { img in
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 1)
                    }

                    Text(item.title)
                        .font(Font.system(.body, design: .rounded))
                    Spacer()
                    item.subtitle.flatMap { text in
                        Text(text)
                            .font(item.subtitleFont)
                            .foregroundColor(Color.secondary)
                    }
                    CheckboxView(isCheked: .constant(self.selection.hashValue == item.hashValue))
                        .frame(width: 20, height: 20)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(Color.text)
        }
    }

}

struct ItemPickerView_Previews: PreviewProvider {

    enum TestItems: String, PickableItem, CaseIterable {
        case one, two

        var title: String {
            return UUID().uuidString
        }

        var subtitle: String? {
            return Bool.random() ? rawValue : nil
        }
    }

    static var previews: some View {
        let items = TestItems.allCases
        Preferences.shared.colorTheme = .purpleRose
        return ItemPickerView(
            selection: .constant(items.randomElement()!),
            header: "Header",
            items: items,
            footer: "Footer"
        )
        .environment(\.colorScheme, .dark)
    }
    
}
