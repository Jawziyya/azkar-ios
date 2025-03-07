// Copyright © 2025 Azkar
// All Rights Reserved.

import SwiftUI

public struct PickerMenu<T: Identifiable & Hashable>: View {
    let title: String
    @Binding var selection: T
    let items: [T]
    let itemTitle: (T) -> String
    
    public init(
        title: String,
        selection: Binding<T>,
        items: [T],
        itemTitle: @escaping (T) -> String
    ) {
        self.title = title
        self._selection = selection
        self.items = items
        self.itemTitle = itemTitle
    }
    
    public var body: some View {
        Menu {
            ForEach(items, id: \.self) { item in
                Button {
                    selection = item
                } label: {
                    Text(itemTitle(item))
                        .systemFont(.callout)
                    if selection == item {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accent)
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                    .systemFont(.body)
                    .foregroundStyle(.text)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(itemTitle(selection))
                    .systemFont(.callout)
                    .foregroundStyle(.secondaryText)
                Image(systemName: "chevron.down")
                    .foregroundStyle(.secondaryText)
            }
            .padding(.vertical, 8)
        }
    }
}

@available(iOS 17, *)
#Preview {
    struct PreviewModel: Identifiable, Hashable {
        let id = UUID()
        let name: String
        
        static let samples = [
            PreviewModel(name: "Option 1"),
            PreviewModel(name: "Option 2"),
            PreviewModel(name: "Option 3")
        ]
    }
    
    @Previewable @State var selected = PreviewModel.samples[0]
    
    return VStack {
        PickerMenu(
            title: "Select an option",
            selection: $selected,
            items: PreviewModel.samples,
            itemTitle: { $0.name }
        )
        .padding()
    }
}
