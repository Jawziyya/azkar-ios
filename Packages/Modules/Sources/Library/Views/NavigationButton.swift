// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

public struct NavigationButton: View {
    
    let title: String
    let label: String?
    let action: () -> Void
    let applyVerticalPadding: Bool
    @Environment(\.colorTheme) var colorTheme
    
    public init(
        title: String,
        label: String? = nil,
        applyVerticalPadding: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.label = label
        self.applyVerticalPadding = applyVerticalPadding
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            NavigationLabel(
                title: title,
                label: label,
                applyVerticalPadding: applyVerticalPadding
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    NavigationButton(title: "Go to settings", action: {})
}
