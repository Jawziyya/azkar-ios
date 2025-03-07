import SwiftUI

public struct ZikrNoteView: View {
    
    let text: String
    @Environment(\.highlightPattern)
    var pattern: String?
    
    public init(
        text: String
    ) {
        self.text = text
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(.accent)
            Text(attributedString(text, highlighting: pattern))
        }
        .padding()
    }
    
}

#Preview {
    ZikrNoteView(text: "Test")
        .environment(\.highlightPattern, "est")
}
