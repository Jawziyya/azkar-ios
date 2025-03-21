import SwiftUI
import Library

struct ItemPickerView<SelectionValue>: View where SelectionValue: Hashable & Identifiable & PickableItem {

    @Environment(\.presentationMode) var presentationMode
    @Binding var selection: SelectionValue
    var header: String?
    let items: [SelectionValue]
    var footer: String?
    var dismissOnSelect = false
    var enableHapticFeedback = true
    var isItemProtected: (SelectionValue) -> Bool = { _ in false }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let header {
                Text(header)
                    .systemFont(.callout, modification: .smallCaps)
                    .foregroundStyle(.text)
            }
            
            LazyVStack(spacing: 0) {
                content
            }
            .padding(.horizontal)
            
            if let footer {
                Text(footer)
                    .systemFont(.caption)
                    .foregroundStyle(.secondaryText)
            }
        }
    }

    var content: some View {
        ForEachIndexed(items) { _, position, item in
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
                        .systemFont(.body)
                    Spacer()
                    item.subtitle.flatMap { text in
                        Text(text)
                            .systemFont(.footnote)
                            .foregroundStyle(Color.secondary)
                    }
                    
                    if isItemProtected(item) && selection.hashValue != item.hashValue {
                        ProBadgeView()
                    } else {
                        CheckboxView(isCheked: .constant(selection.hashValue == item.hashValue))
                            .frame(width: 20, height: 20)                        
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundStyle(.text)
            .padding()
            .background(.contentBackground)
            .applyTheme(indexPosition: position)
        }
    }

}

struct ItemPickerView_Previews: PreviewProvider {

    enum TestItems: String, Identifiable, PickableItem, CaseIterable {
        case one, two
        
        var id: Self {
            self
        }

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
        .background(.background, ignoreSafeArea: .all)
        .environment(\.colorScheme, .dark)
    }
    
}
