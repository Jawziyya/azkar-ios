import SwiftUI

public struct ZikrBenefitsView: View {
    
    public let text: String
    // TODO: Support for Translation font.
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("💎")
                .minimumScaleFactor(0.1)
                .font(Font.largeTitle)
                .frame(maxWidth: 20, maxHeight: 15)
                .foregroundStyle(Color.accent)
            Text(text)
                .font(.footnote)
        }
        .padding()
    }
    
}

#Preview {
    ZikrBenefitsView(text: """
    #Preview {
        ZikrBenefitsView(text: "")
    }
    """)
}
