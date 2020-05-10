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
    let items: [SelectionValue]
    var dismissOnSelect = false
    var enableHapticFeedback = true

    var body: some View {
        List(items, id: \.title) { item in
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
                Spacer()
                item.subtitle.flatMap { text in
                    Text(text)
                        .font(item.subtitleFont)
                        .foregroundColor(Color.secondary)
                }
                CheckboxView(isCheked:  .constant(self.selection.hashValue == item.hashValue))
                    .frame(width: 20, height: 20)
            }
            .buttonStyle(DefaultButtonStyle())
            .padding(.vertical, 10)
            .background(Color(.secondarySystemGroupedBackground))
            .onTapGesture {
                if item != self.selection {
                    self.selection = item
                    UISelectionFeedbackGenerator().selectionChanged()
                }
                if self.dismissOnSelect {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
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
        return ItemPickerView(
            selection: .constant(items.randomElement()!),
            items: items
        )
    }
}
