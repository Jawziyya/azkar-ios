import SwiftUI

struct HeaderView: View {
    let text: String
    var body: some View {
        Text(text)
            .systemFont(.title3, modification: .smallCaps)
            .foregroundStyle(.secondaryText)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 30)
    }
}
