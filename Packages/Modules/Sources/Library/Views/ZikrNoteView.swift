import SwiftUI

public struct ZikrNoteView: View {
    
    let text: String
    let font: Font
    @Environment(\.highlightPattern)
    var pattern: String?
    
    public init(
        text: String,
        font: Font
    ) {
        self.text = text
        self.font = font
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.accent)
            Text(attributedString(text, highlighting: pattern))
                .font(font)
        }
        .padding()
    }
    
}

#Preview {
    ZikrNoteView(text: "Test", font: .callout)
        .environment(\.highlightPattern, "est")
}
