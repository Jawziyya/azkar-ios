import SwiftUI

public struct NavigationLabel: View {
        
    let title: String
    let label: String?
    let applyVerticalPadding: Bool
    
    public init(
        title: String,
        label: String? = nil,
        applyVerticalPadding: Bool = true
    ) {
        self.title = title
        self.label = label
        self.applyVerticalPadding = applyVerticalPadding
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.leading)
            Spacer()
            if let label {
                Text(label)
                    .foregroundStyle(Color.secondaryText)
                    .multilineTextAlignment(.trailing)
                    .systemFont(.callout)
            }
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.secondaryText)
        }
        .systemFont(.body)
        .padding(.vertical, applyVerticalPadding ? 8 : 0)
    }
    
}

#Preview {
    NavigationLabel(title: "Arabic Font", label: "Adobe")
}
