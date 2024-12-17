// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

public struct ChevronButton: View {
    
    let title: String
    let action: () -> Void
    
    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(Color.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondary)
            }
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    ChevronButton(title: "Go to settings", action: {})
}
