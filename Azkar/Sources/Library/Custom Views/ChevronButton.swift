// Copyright © 2023 Azkar
// All Rights Reserved.

import SwiftUI

struct ChevronButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
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
